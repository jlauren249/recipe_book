class Recipe

    # def new_ingredient i, p
    #     @ingredient = i
    #     @price = p            
    # end
    

end

def add_recipe r, d, i
    command = DB.prepare "INSERT INTO Recipes (recipeName, Description) VALUES ('#{r}', '#{d}')"
    command.execute
    command.close if command

    recipeID = 0
    command = DB.prepare "SELECT recipeID FROM Recipes where [recipeNAME]='#{r}'"
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

def get_recipe
    command = DB.prepare "SELECT * FROM Recipes"
    reader = command.execute
    reader.each do |y|
        print y
    end
    command.close if command
end