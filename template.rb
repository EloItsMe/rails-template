# Stylesheets
########################################
run 'rm -rf app/assets/stylesheets'
run "curl -L https://github.com/EloItsMe/rails-stylesheet-structure/archive/refs/tags/release.zip > stylesheets.zip"
run "unzip stylesheets.zip -d app/assets && rm -f stylesheets.zip"
run "mv app/assets/rails-stylesheet-structure-release app/assets/stylesheets"
########################################
