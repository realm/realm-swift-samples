exports = async function(userId, transactionResult){
  var serviceName = "mongodb-atlas";
  var dbName = "foodie-folio";
  var collName = "Purchase";
  
  var purchasesCollection = context.services.get(serviceName).db(dbName).collection(collName);
  
  var receipt = JSON.parse(transactionResult);

    return purchasesCollection.insertOne({
    userId: userId,
    receipt: receipt
  });
};