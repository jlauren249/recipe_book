class Ingredient

    attr_accessor :ingredientName

    def show_ingredient 
       get_ingredient

       @ingredientArray.each do |x|
            if @ingredientName == nil
                puts x
            else
                puts "Ingredient: #{x[1]}"
                puts "Price: $#{x[2]}"
                puts "Recipes:"
                @ingredientID = x[0]
                get_ingredient_recipes
                @ingredientRecipesArray.each do |y|
                    puts y
                end
            end
       end
    end

    def get_ingredient_recipes
       @ingredientRecipesArray = Array.new
       command = DB.prepare "SELECT Recipes.recipeName FROM Recipes JOIN joiner ON Recipes.recipeID=joiner.recipeID WHERE joiner.ingredientID=#{@ingredientID}"
       reader = command.execute
       reader.each do |recipe|
           @ingredientRecipesArray << recipe[0]
       end
       command.close if command
   end

    def get_ingredient
        @ingredientArray = Array.new
        if @ingredientName == nil
            command = DB.prepare "SELECT * FROM Ingredients"
            reader = command.execute
            reader.each do |y|
                @ingredientArray << y[1]
            end
            command.close if command
        else 
            command = DB.prepare "SELECT * FROM Ingredients WHERE ingredient='#{@ingredientName}'"
            reader = command.execute
            reader.each do |y|
                @ingredientArray << y
            end
            command.close if command
        end   
    end
end

def add_ingredient i, p
    command = DB.prepare "INSERT INTO Ingredients (ingredient, ingredientPrice) VALUES ('#{i}', #{p})"
    command.execute
    command.close if command
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