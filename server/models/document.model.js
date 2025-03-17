const mongoose = require('mongoose');

const documentSchema = new mongoose.Schema({
    uid: {type:String,required:true},
    title:{type:String,required:true,trim:true},
    contents:{type:Array,default:[]},
    createdAt: {
        required:true,
        type: Number
    }
},);

const Document = mongoose.model('Document', documentSchema);
module.exports = Document;