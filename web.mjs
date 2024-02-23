import express from "express";
import {Liquid} from "liquidjs";
import bodyParser from "body-parser";
import cookieParser from "cookie-parser";
import * as db from "./db.mjs";
import {fetch} from "undici";
import * as crypto from "crypto";


let app = express();
let engine = new Liquid({
    "cache": process.env.NODE_ENV === "PROD"
})
app.use(cookieParser());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ "extended": true }));
app.engine("liquid", engine.express());
app.set("views", [
    "./views"
]);
app.set("trust proxy", "loopback")
app.set("view engine", "liquid");
app.use("/static", express.static("static"));


app.use(async (req,res,next)=>{

    app.locals.session = req.cookies?.session_token ?? null

    app.locals.user = null;
    if(app.locals.session){
        app.locals.user = await db.getUserFromSession(app.locals.session)
    }

    next()
})

app.get("/",async (req,res)=>{
    res.render("index.liquid",{
        gameItems: await db.getItemsOfTeam(0),
        teams: await db.getTeams(),
        elections: await db.getActiveElections(),
        user: app.locals.user,
        userTeam: app.locals.user ? (await db.getTeam(app.locals.user.team)) : null,
        userElections: app.locals.user ? (await db.getUserElections(app.locals.user.id)).map((val)=>val.election) : []
    })
})

app.get("/all-7A9d3G",async (req,res)=>{
    res.render("index.liquid",{
        gameItems: await db.getItemsOfTeam(0),
        teams: await db.getTeams(),
        elections: await db.getAllElections(),
        user: app.locals.user,
        userTeam: app.locals.user ? (await db.getTeam(app.locals.user.team)) : null,
        userElections: app.locals.user ? (await db.getUserElections(app.locals.user.id)).map((val)=>val.election) : []
    })
})

app.get("/about", async (req,res)=>{
    res.render("about.liquid")
})

app.get("/login", (req,res)=>{
    res.redirect(`https://discord.com/api/oauth2/authorize?client_id=${process.env.DCCLIENT}&response_type=code&redirect_uri=${encodeURIComponent(process.env.DCURI)}&scope=identify`)
})

app.get("/auth", async (req, res) =>{
    let {code} = req.query
    fetch(`https://discord.com/api/oauth2/token`
    ,{
        method: "POST",
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            client_id: process.env.DCCLIENT,
            client_secret: process.env.DCSECRET,
            code,
            grant_type: 'authorization_code',
            redirect_uri: process.env.DCURI,
            scope: 'identify',
        }).toString()
    })
    .then(response=>response.json())
    .then(async (response)=>{
        
        let userResponse = await fetch('https://discord.com/api/users/@me', {
			headers: {
				authorization: `Bearer ${response.access_token}`,
			},
		}).then(ures=>ures.json())

        if(!userResponse.id) return res.status(500).send("500")

        let user = (await db.createOrGetUser(userResponse.id, userResponse.username))[0]
        let session = crypto.randomBytes(8).toString('hex')
        await db.authUser(userResponse.id, session, response.access_token)
        res.cookie("session_token", session)

        res.redirect('/')
    })
})

app.get("/logout", async (req, res)=>{

    await db.deauthUser(app.locals.session)
    res.clearCookie("session_token")
    res.redirect("/")
})

app.post("/changeteam", async (req, res) =>{
    
    if(!app.locals.session || !req.body.team_selector) return res.status(400).send(400);

    await db.changeUserTeam(app.locals.session, req.body.team_selector)

    res.redirect("/")
})

app.post("/vote", async (req, res)=>{


    let election_id = req.body.election_id
    let vote_item_id = req.body[`election_${election_id}`]

    if(!election_id || !vote_item_id) return res.status(400).send(400);

    if(!app.locals.user.team) return
    await db.createVote(app.locals.user.id, election_id, vote_item_id, app.locals.user.team)


    res.redirect("/")
})


export {
    app
}
