const express = require('express');
const mongoose = require('mongoose');
const app = express();
const cors = require('cors');
app.use(cors());
const http = require('http');
app.use(express.json());
require('dotenv').config();
const authRouter = require('./routers/auth.router');
const docRouter = require('./routers/document.router');
const DocumentService = require("./services/documentService")
const docService = new DocumentService();

var server = http.createServer(app);
var io = new require('socket.io')(server);


app.use("/api/auth", authRouter);
app.use("/api/docs", docRouter);




const DB = process.env.MONGO_CONNECTION_STRING;
const PORT = process.env.PORT || 3001;
mongoose.connect(DB).then(() => {
    console.log('Connected to MongoDB');

    io.on("connection", (socket) => {
        console.log('Connected: ' + socket.id);
        socket.on('join', (docId) => {
            socket.join(docId);
            console.log("joined " + docId);
        });
        socket.on("typing", (data)=>{
            socket.broadcast.to(data.room).emit("changes",data);
        });
        socket.on("save", (data)=>{
            saveData(data);
        });

    });

    server.listen(PORT, "0.0.0.0", () => {
        console.log(`Server listening on port ${PORT}`);
    });

}).catch(err => {
    console.log('Error: ', err.message);
});


const saveData = async (data)=>{
    try {
        let document = await docService.getSingleDocument(data.room);
        

        if (!document) {
            throw new Error(`Document not found for room: ${data.room}`);
        }

        document.content = data.delta;
        await document.save();  // Save the updated document
    } catch (error) {
        console.error("Error saving data:", error);
    }
}


