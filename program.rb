require "./lib/recipe.rb"
require "./lib/ingredient.rb"
require 'sqlite3' # this allows us to use sqlite databases

begin
DB = SQLite3::Database.open "recipebook.sqlite"

keepGoing = true
while keepGoing == true

puts "Hello! Would you like to:"
puts "1. See all of your recipes"
puts "2. Find a recipe"
puts "3. Add a recipe"
puts "4. See all of your ingredients"
puts "5. Find an ingredient"
puts "6. Add an ingredient"
puts "7. quit"

choice = gets.chomp

if choice == "1"
    #see all recipes
    allRecipes = Recipe.new
    allRecipes.show_recipe
elsif choice == "2"
    #find one recipe
    puts "Which recipe would you like to see?"
    recipe = gets.chomp.downcase
    chosenRecipe = Recipe.new
    chosenRecipe.recipeName = recipe
    chosenRecipe.show_recipe
elsif choice == "3"
    #add a recipe
    puts "What recipe would you like to add today?"
    recipe = gets.chomp.downcase

    puts "Please provide a description of a #{recipe}."
    description = gets.chomp.downcase

    puts "What ingredients are in this recipe? (please seperate ingredients with a ,)"
    #formats the ingredients list regardless of how spaces are entered
    recipeIngredients = gets.chomp.downcase.gsub(" , ", ",").gsub(", ",",").gsub(" ,",",")

    # puts "You want to add #{recipe} which you describe as '#{description}' and contains #{recipeIngredients}."

    #call function to check that all ingredients entered as part of this recipe are already in the DB
    newIngredientsArray = check_ingredient recipeIngredients
    if newIngredientsArray[0] == nil
        puts "No new ingredients here. Your recipe has been added!"
    else
        #adds any new ingredients to the ingredients table
        puts "This is the first recipe to use one or more of these ingredients."
        newIngredientsArray.each do |x|
            puts "How much does #{x} cost?"
            price = gets.chomp
                if price.include?("$")
                    price = price.gsub("$","").to_f
                end
            puts "You are adding #{x} at $#{price.to_s} to the book."
            add_ingredient x, price
        end
    end

    #adds all of the information to the recipes and joiner tables
    add_recipe recipe, description, recipeIngredients
elsif choice == "4"
    #see all ingredients
    allIngredients = Ingredient.new
    allIngredients.show_ingredient
elsif choice == "5"
    #find an ingredient
    puts "What ingredient would you like to see?"
    ingredient = gets.chomp.downcase
    chosenIngredient = Ingredient.new
    chosenIngredient.ingredientName = ingredient
    chosenIngredient.show_ingredient

elsif choice == "6"
    #add an ingredient
    puts "What ingredient would you like to add to your recipe book?"
    ingredient = gets.chomp.downcase

    puts "And how much does this cost?"
    price = gets.chomp

    if price.include?("$")
        puts "this has a $"
        price = price.gsub("$","").to_f
    else
        puts "this does not have a $"
    end

    # puts "You are adding #{ingredient} at $#{price.to_s} to the book."

    puts "Your ingredient has been added!"
    add_ingredient ingredient, price

elsif choice == "7"
    #quit
    keepGoing = false
    puts "Have a good day!"
else 
    puts "Please enter a valid selection."
    puts
end
end

# close the database
DB.close if DB
end