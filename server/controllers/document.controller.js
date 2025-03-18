const DocumentService = require("../services/documentService")
const docService = new DocumentService();

module.exports = class AuthController {

    async CreateDoc(req, res) {
        try {
            const { createdAt } = req.body;
            const result = await docService.createDocument(req.user, createdAt)
            if (result) {
                res.status(200).json({
                    message: "Document created.",
                    document: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }
    async UpdateDocTitle(req, res) {
        try {
            const { id , title } = req.body;
            const result = await docService.updateDocTitle(id, title)
            if (result) {
                res.status(200).json({
                    message: "Document Updated.",
                    document: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }

    async GetAllDoc(req, res) {
        try {
            const result = await docService.getDocuments(req.user)
            if (result) {
                res.status(200).json({
                    message: "Document fetched",
                    documents: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }
    async GetSingleDoc(req, res) {
        try {
            const result = await docService.getSingleDocument(req.params.id)
            if (result) {
                res.status(200).json({
                    message: "Document fetched",
                    document: result,
                });
            }
        } catch (error) {
            console.log(error);
            res.status(500).json({
                error: "Internal Server error:",
            });
        }
    }




}