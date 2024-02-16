import fs from "fs/promises";
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
        await sql.file(`./db_versions/version_${updateVersion}.sql`)
        console.log("Applied version "+(await sql`select database_version from "settings" where id=0;`)[0].database_version)
    }
    console.log("Updates finished!")
}

async function processContentUpdates(){
    let processedFiles = (await sql`select file_name from "updates";`).map(res=>res.file_name)
    // console.log("Already Processed Files:", processedFiles)
    let contentFiles = await fs.readdir("./db_content")
    // console.log("Content Files:", contentFiles)
    let filesToProcess = contentFiles.filter(val=>{return !(processedFiles.includes(val))})
    if (filesToProcess.length === 0) {
        return
    }
    console.log("Files to process:", filesToProcess)
    filesToProcess.forEach(async file => {
        console.log("Processing ", file)
        await sql.file(`./db_content/${file}`);
    });

}

export {
    processUpdates,
    processContentUpdates
}