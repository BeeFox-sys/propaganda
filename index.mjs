import 'dotenv/config';
import * as db from "./db.mjs";
import { CronJob } from "cron";
import * as web from "./web.mjs";
import moment from 'moment';

async function init(){
    
    await updateJobs()

    // console.log(await db.getTeams())

    contentUpdateJob.start();
    web.app.listen(process.env.PORT, ()=>{
        console.log("Web service started on port",process.env.PORT);
    })
}

async function updateJobs(){
    await db.processUpdates();
    await db.processContentUpdates();
    await createElectionCronjobs()
}

let electionJobs = {};
async function createElectionCronjobs() {
    let elections = await db.getActiveElections();
    for (let index = 0; index < elections.length; index++) {
        const election = elections[index];
        if(election.processed) return;
        // console.log(election);
        let timeLeft = election.vote_end - new Date();
        if(timeLeft >= 2145600000 ) {
            console.warn(`Warning: Election ${election.id} is more then 596 hours away, and as such cannot be scheduled right now.`)
            continue;
        }
        if(electionJobs[election.id]) continue;
        electionJobs[election.id] = setTimeout(processElection, timeLeft, election)
        console.log(`Scheduled election ${election.id} ${moment(election.vote_end).fromNow()}`)
    }
}

function processElection(election){
    console.log(`Processing Election ${election.id} of type ${election.mode}`)
    switch (election.mode) {
        case "raffle":
            runRaffelElection(election.id);
            break;
        case "majority":
            runMajorityElection(election.id);
            break;
        default: 
            console.error("Invalid Election Mode!")
            return;
    }
}


function shuffleArray(input_array) {
    let array = Array.from(input_array);
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]];
    }
    return array;
}

async function runMajorityElection(election_id){
    console.log("Majority", election_id)
    let voteCount = await db.countVotesForElection(election_id);
    if(voteCount.length === 0) {   
        let electionItems = Array.from(await db.getItemsForElection(election_id));
        let randItem = electionItems[Math.floor(Math.random()*electionItems.length)]
        await db.assignItemToTeam(randItem.id, 0);
        db.markElectionProcessed(election_id);
        return
    };
    let winner = await voteCount.sort((a,b)=>a.countof > b.countof)[0];
    await db.assignItemToTeam(winner.item, 0);
    db.markElectionProcessed(election_id);
}

async function runRaffelElection(election_id){
    console.log("Raffle", election_id)
    let electionVotes = Array.from(await db.getVotesForElection(election_id));
    let electionItems = Array.from(await db.getItemsForElection(election_id));
    let teams = Array.from(await db.getTeams());  
    
    while (teams.length > 0 && electionItems.length > 0 && electionVotes.length > 0) {
    // while (not all teams have item) and (more items to distribute) and (votes remaining)
        // select random ticket
        let ticket = shuffleArray(electionVotes)[0];
        // assign item to team on ticket
        // if(election_id == 13) console.log(ticket.item, ticket.team)
        db.assignItemToTeam(ticket.item, ticket.team);
        // remove item from electionItems
        let itemIndex = electionItems.findIndex((val)=>val.id===ticket.item);
        electionItems.splice(itemIndex, 1);
        // remove team from teams
        let teamIndex = teams.findIndex((val)=>val.id===ticket.team);
        teams.splice(teamIndex, 1);
        // remove votes for team or item from electionVotes
        electionVotes = electionVotes.filter((vote)=>(vote.item !== ticket.item && vote.team !== ticket.team))
    }

    // if(election_id == 13) console.log(teams.length)

    if (teams.length > 0 && electionItems.length > 0 && electionVotes.length === 0) {

    let itemLength = electionItems.length;
    // if (not all teams have item) and (more items to distribute) and (no votes remaining)
        for (let index = 0; index < itemLength; index++) {
            const item = electionItems[index];
            if (teams.length === 0) break;
            let team = shuffleArray(teams)[0]
            // console.log(item.name, team.name)
            db.assignItemToTeam(item.id, team.id)

            let teamIndex = teams.findIndex((val)=>val.id===team.id);
            teams.splice(teamIndex, 1);
        }
    }
    
    db.markElectionProcessed(election_id)
}


const contentUpdateJob = new CronJob(
    '0 0 * * * *',
    updateJobs
);

init();