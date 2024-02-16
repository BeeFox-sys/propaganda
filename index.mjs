import 'dotenv/config';
import * as db from "./db.mjs";
import { CronJob } from "cron";

async function init(){
    await db.processUpdates();
    await db.processContentUpdates();
    // setInterval(db.processContentUpdates, 60*1000)
    contentUpdateJob.start();
}

const contentUpdateJob = new CronJob(
    '0 0 * * * *',
    db.processContentUpdates
)

init();