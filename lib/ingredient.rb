class Ingredient

    # def new_ingredient i, p
    #     @ingredient = i
    #     @price = p            
    # end

end

def add_ingredient i, p
    command = DB.prepare "INSERT INTO Ingredients (ingredient, ingredientPrice) VALUES ('#{i}', #{p})"
    command.execute
    command.close if command
end

def get_ingredient
    command = DB.prepare "SELECT * FROM Ingredients"
    reader = command.execute
    ingredientArray = Array.new
    reader.each do |y|
        ingredientArray << y[1]
    end
    command.close if command
    return ingredientArray
end

def check_ingredient x
    newIngredientArray = Array.new
    recipeArray = Array.new
    tempVar = ""
    x.each_char do |letter|
        if letter == ","
            recipeArray << tempVar
            tempVar = ""
        else
            tempVar = tempVar + letter
        end
    end
    recipeArray << tempVar

    recipeArray.each do |recipeIngredient|
        if get_ingredient.include?(recipeIngredient)
            # puts "#{recipeIngredient} already exists"
        else
            newIngredientArray << recipeIngredient
            # puts "#{recipeIngredient} does not exist"
        end
    end
    return newIngredientArray
end

def get_ingredientIDs i
    sql = i.gsub(",","' OR ingredient='")
    command = DB.prepare "SELECT ingredientID FROM Ingredients WHERE ingredient='#{sql}'"
    reader = command.execute
    ingredientIDArray = Array.new
    reader.each do |y|
        ingredientIDArray << y
    end
    command.close if command
    return ingredientIDArray
end