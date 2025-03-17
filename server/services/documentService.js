
const DocumentModel = require('../models/document.model');

module.exports = class DocumentService {
   async createDocument (userid,docCreatedAt){
        let doc = new DocumentModel({
            uid:  userid,
            title: "Untitled Document",
            createdAt: docCreatedAt
        });
        const document= await doc.save();
        return document;
   }
};