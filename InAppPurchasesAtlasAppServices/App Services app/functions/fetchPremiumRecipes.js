exports = async function(arg){
  const axios = require('axios');
  
  var serviceName = "mongodb-atlas";
  var dbName = "foodie-folio";
  var collName = "Recipes";
  
  var edamamAppID = context.values.get('YOUR_EDAMAM_APP_ID');
  var edamamAPIKey = context.values.get('YOUR_EDAMAM_API KEY');
  
  // Change this and add it as url query parameters instead
  const diet = "low-carb";
  const premiumRecipes = "Japanese"
  var queryString = `?type=any&app_id=${edamamAppID}&app_key=${edamamAPIKey}&cuisineType=${premiumRecipe}&diet=${diet}`;
  var baseURL = "https://api.edamam.com/api/recipes/v2";
  
  const endpoint = baseURL + queryString;
  
  console.log(endpoint);

  // Get a collection from the context
  var collection = context.services.get(serviceName).db(dbName).collection(collName);

  try {
    const response = await axios.get(endpoint);
    const recipes = response.data.hits;
    
    for (const recipe of recipes) {
      const recipeObject = recipe.recipe // Avoid duplication of field and improve readability
      const recipeURI = recipeObject.uri; // Assuming the URI is accessible this way
      
      // Use the recipe URI as the unique identifier
      const filter = { uri: recipeURI };

      const dataToUpsert = {
        uri: recipeObject.uri,
        calories: recipeObject.calories,
        cautions: recipeObject.cautions,
        cuisineType: recipeObject.cuisineType,
        dietLabels: recipeObject.dietLabels,
        dishType: recipeObject.dishType,
        healthLabels: recipeObject.healthLabels,
        image: recipeObject.image,
        ingredientLines: recipeObject.ingredientLines,
        ingredients: recipeObject.ingredients,
        label: recipeObject.label,
        mealType: recipeObject.mealType,
        shareAs: recipeObject.shareAs,
        source: recipeObject.source,
        totalCO2Emissions: recipeObject.totalCO2Emissions,
        totalTime: recipeObject.totalTime,
        totalWeight: recipeObject.totalWeight,
        url: recipeObject.url,
        yield: recipeObject.yield
      };
      
      // Update document with the new data, or insert if it doesn't exist
      const updateData = {
        $set: dataToUpsert
      };
      
      const updateResult = await collection.updateOne(
        filter,
        updateData,
        { upsert: true } // Enable upsert option
      );
      
      console.log("Upsert result:", updateResult);
    }

    return "Upsert operation completed";

  } catch(err) {
    console.log("Error occurred while executing findOne:", err.message);

    return { error: err.message };
  }
};