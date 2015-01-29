echo "What's the name of your app?"

read app

LOWER=$(echo $app | tr '[A-Z]' '[a-z]')

echo "---> Setting up database.yml"
sed -i "" "s/boilerapp/$LOWER/g" config/database.yml
echo "---> Setting up Rakefile"
sed -i "" "s/Boilerapp/$app/g" Rakefile
echo "---> Setting up config.ru"
sed -i "" "s/Boilerapp/$app/g" config.ru
echo "---> Updating app name globally"
find . -name "*.rb" -exec sed -i "" "s/Boilerapp/$app/g" {} \;

echo "All done!"



