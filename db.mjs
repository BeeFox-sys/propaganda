import fs from "fs/promises";
import moment from "moment";
import postgres from "postgres";

const sql = postgres();

async function initalSetup() {
    let settings_exist = await sql `
    SELECT EXISTS (
        SELECT FROM
            pg_tables
        WHERE
            schemaname = 'public' AND
            tablename  = 'settings'
        )`
    if (settings_exist[0].exists) {
        return;
    }
    console.log("Setting Up Database")
    await sql.file("./db_versions/version_0.sql")
}

async function processUpdates() {
    await initalSetup();
    let dbVersion = (await sql`select database_version from "settings" where id=0;`)[0].database_version
    console.log("Database is on version", dbVersion)
    let versionFiles = await fs.readdir("./db_versions")
    let maxVersion = Math.max.apply(0, versionFiles.map((val)=>val.match(/[0-9]+/gm)[0]))

    if(dbVersion === maxVersion){
        console.log("Database is up to date!")
        return
    }
    console.log("Updating database to version", maxVersion)
    for(var updateVersion = dbVersion+1; updateVersion <= maxVersion; updateVersion++){
        sql.begin(async sql => {await sql.file(`./db_versions/version_${updateVersion}.sql`)})
        console.log("Applied version "+(await sql`select database_version from "settings" where id=0;`)[0].database_version)
    }
    console.log("Updates finished!")
}

async function processContentUpdates(){
    let processedFiles = (await sql`select file_name from "update";`).map(res=>res.file_name)
    // console.log("Already Processed Files:", processedFiles)
    let contentFiles = await fs.readdir("./db_content")
    // console.log("Content Files:", contentFiles)
    let filesToProcess = contentFiles.filter(val=>{return !(processedFiles.includes(val))})
    if (filesToProcess.length === 0) {
        return
    }
    console.log("Files to process:", filesToProcess)
    for (let index = 0; index < filesToProcess.length; index++) {
        const file = filesToProcess[index];
        console.log("Processing ", file)
        await sql.begin(async sql => sql.file(`./db_content/${file}`));
    }
}

async function getActiveElections(){
    let activeElections = await sql`
        select * from "election" where 
            display_start <= now()
        AND display_end > now()
        order by display_start
        ;
    `
    for (let electionIndex = 0; electionIndex < activeElections.length; electionIndex++) {
        const election = activeElections[electionIndex];
        if(new Date(election.vote_start).getTime() > Date.now()){
            election.vote_state = 'future'
        } else if (new Date(election.vote_start).getTime() < Date.now() && new Date(election.vote_end).getTime() > Date.now()) {
            election.vote_state = 'now'
        } else {
            election.vote_state = 'past'
        }
        election.time_until_vote_start = moment(election.vote_start).fromNow();
        election.time_until_vote_end = moment(election.vote_end).fromNow();

        election.items = await getItemsForElection(election.id)
    }
    return activeElections;
}

async function getAllElections(){
    let activeElections = await sql`
        select * from "election"
        order by display_start
        ;
    `
    for (let electionIndex = 0; electionIndex < activeElections.length; electionIndex++) {
        const election = activeElections[electionIndex];
        if(new Date(election.vote_start).getTime() > Date.now()){
            election.vote_state = 'future'
        } else if (new Date(election.vote_start).getTime() < Date.now() && new Date(election.vote_end).getTime() > Date.now()) {
            election.vote_state = 'now'
        } else {
            election.vote_state = 'past'
        }
        election.time_until_vote_start = moment(election.vote_start).fromNow();
        election.time_until_vote_end = moment(election.vote_end).fromNow();

        election.items = await getItemsForElection(election.id)
    }
    return activeElections;
}

async function getItemsForElection(election_id){
    let items = await sql`
        select * from "item" where 
            election = ${election_id}
            order by id;
        ;
    `
    for (let index = 0; index < items.length; index++) {
        const item = items[index];
        if(item.winner){
            items[index].winner_object = await getTeam(item.winner);
        }
    }
    return items;
}

async function assignItemToTeam(item_id, team_id){
    await sql`
        update "item" 
        set winner = ${team_id}
        where id = ${item_id}
        ;
    `
}

async function getTeams() {
    let teamIDs = await sql `
        select id from "team" where id != 0 order by id;
    `
    let teams = []

    for (let index = 0; index < teamIDs.length; index++) {
        const teamID = teamIDs[index];
        teams.push(await getTeam(teamID.id))
    }
    
    return teams
}

async function getTeam(team_id) {
    let team = (await sql`
        select * from "team" where id = ${team_id};
    `)[0]
    if(!team) return team;
    team.items = Array.from(await getItemsOfTeam(team_id));
    return team
}

async function getItemsOfTeam(team_id){
    let items = await sql`
        select * from "item" where winner = ${team_id};
    `
    return items
}

async function createOrGetUser(discord_id, username){
    let user = await sql`
        select * from users where discord_id = ${discord_id};
    `
    if(user && !username) return user
    return await sql`
        insert into users (discord_id, username) values (${discord_id}, ${username}) on CONFLICT(discord_id) do update set username = ${username} returning *;
    `
}

async function changeUserTeam(session_token, team) {
    return sql`
        update users set team = ${team} where session_token = ${session_token};
    `
}

async function getUserFromSession(session_token){
    return (await sql`
        select * from users where session_token = ${session_token};
    `)[0]
}

async function authUser(discord_id, session_token, auth_token) {
    return await sql`
        update users set session_token = ${session_token}, discord_access_token = ${auth_token} where discord_id = ${discord_id} returning *;
    `
}

async function deauthUser(session_token){
    return await sql`
        update users set session_token = null, discord_access_token = null where session_token = ${session_token} returning *;
    `
}

async function createVote(user_id, election_id, item_id, team_id){
    await sql`
        INSERT INTO vote (user_id, election, item, team)
        VALUES (${user_id},${election_id},${item_id},${team_id});
    `
}

//this is for the majority counts
async function countVotesForElection(election_id) {
    return await sql`
        select item, count(item) AS countof from "vote" where election = ${election_id} group by item;
    `
}

async function getVotesForElection(election_id){
    return await sql `
        select * from "vote" where election = ${election_id};
    `
}

async function getVotesForItem(item_id) {
    return await sql `
        select * from "vote" where item = ${item_id};
    `
}

async function markElectionProcessed(election_id){
    return await sql `
        update election set processed = true where id = ${election_id};
    `
}

async function getUserElections(user_id) {
    return await sql `
    select distinct(election) from vote where user_id = ${user_id};
    `
}

export {
    processUpdates,
    processContentUpdates,
    getActiveElections,
    getAllElections,
    getItemsForElection,
    assignItemToTeam,
    getTeam,
    getTeams,
    getItemsOfTeam,
    createVote,
    countVotesForElection,
    getVotesForElection,
    getVotesForItem,
    markElectionProcessed,
    createOrGetUser,
    authUser,
    getUserFromSession,
    deauthUser,
    changeUserTeam,
    getUserElections
}