class Recipe
    
    attr_accessor :recipeName

     def show_recipe 
        get_recipe

        @recipeArray.each do |x|
            puts "Name: #{x[0]}"
            puts "Description: #{x[1]}"
            puts "Ingredients:"
            @recipeName = x[0]
            get_recipe_ingredients
            @recipeIngredientsArray.each do |y|
                puts y
            end
            puts
        end
     end

     def get_recipe_ingredients
        @recipeIngredientsArray = Array.new
        command = DB.prepare "SELECT Ingredients.ingredient FROM Ingredients JOIN joiner ON Ingredients.ingredientID=joiner.IngredientID WHERE joiner.recipeID=(SELECT Recipes.recipeID FROM Recipes WHERE Recipes.recipeName='#{@recipeName}')"
        reader = command.execute
        reader.each do |ingredientID|
            @recipeIngredientsArray << ingredientID[0]
        end
        command.close if command
    end
    
    def get_recipe
        @recipeArray = Array.new
        if @recipeName == nil
            command = DB.prepare "SELECT * FROM Recipes"
            reader = command.execute
            reader.each do |y|
                @recipeArray << y[1,2]
            end
            command.close if command
        else
            command = DB.prepare "SELECT * FROM Recipes WHERE recipeName='#{@recipeName}'"
            reader = command.execute
            reader.each do |y|
                @recipeArray << y[1,2]
            end
            command.close if command
        end
    end

end

def add_recipe r, d, i
    command = DB.prepare "INSERT INTO Recipes (recipeName, Description) VALUES ('#{r}', '#{d}')"
    command.execute
    command.close if command

    recipeID = 0
    command = DB.prepare "SELECT recipeID FROM Recipes where recipeName='#{r}'"
    reader = command.execute
    reader.each do |y|
        recipeID = y[0]
    end
    command.close if command
    
    ingredientIDsArray = Array.new
    ingredientIDsArray = get_ingredientIDs i
    
    add_recipe_ingredients recipeID, ingredientIDsArray
end

def add_recipe_ingredients r, i
    i.each do |x|
        print x
        command = DB.prepare "INSERT INTO joiner (recipeID, ingredientID) VALUES (#{r}, #{x[0]})"
        command.execute
        command.close if command
    end
end