
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
   async updateDocTitle (docId,title){
        const document= await DocumentModel.findByIdAndUpdate(docId , {title},  { new: true, runValidators: true } );
        return document;
   }
   async getDocuments (userid){
        const documents= await DocumentModel.find({uid:userid});
        return documents;
   }
   async getSingleDocument (docId){
        const documents= await DocumentModel.findById(docId);
        return documents;
   }
};