# README
Assumptions:

*bussiness developer can only create leads and add phases to them 
*respective BD's can add comment to their leads and phases
*manager can only add comment to the phase he assigned to
*only manager can add engineers to the phase
*all users can see everything ,leads phases and comments of others users

Prerequisites :
The setups steps expect following tools installed on the system.

Github :
Ruby 2.4.0
Rails 5.0.2

1. Check out the repository
git clone git@github.com:razianoor5/lead-management-engine.git

2. Create database.yml file
Copy the sample database.yml file and edit the database configuration as required.

cp config/database.yml.sample config/database.yml

3. Create and setup the database
Run the following commands to create and setup the database.

bundle exec rake db:create
bundle exec rake db:setup

4. Start the Rails server
You can start the rails server using the command given below.

bundle exec rails s
And now you can visit the site with the URL http://localhost:3000

