# Lead Management Engine
## Assumptions:

  * bussiness developer can only create leads and add phases to them
  * Bussiness Developer can add comment to the lead he created and associated phases
  * respective BD's can add comment to their leads and phases
  * manager can only add comment to the phase he assigned to
  * only manager can add engineers to the phase
  * all users can see everything ,leads phases and comments of others users

## Prerequisites :
  The setups steps expect following tools installed on the system.
### Github :

```shell
  * Ruby 2.4.0
  * Rails 5.2.4.4
  * Postgres 1.2.3
```
### Check out the repository

```shell
git clone git@github.com:razianoor5/lead-management-engine.git
```
### Create database.yml file
  Copy the sample database.yml file and edit the database configuration as required.

  Copy config/database.yml.sample config/database.yml

### Create application.yml in config directory
  Add your email and password info through which you want to send emails to managers
  Example:
  application.yml

  ```shell
  default_mail: 'your-email.com'
  password: 'your-email-password'
  ```
### Create and setup the database
  Run the following commands to create and setup the database.

  ```shell
  bundle exec rake db:create
  bundle exec rake db:setup
  ```
### Start the Rails server
  You can start the rails server using the command given below.

  ```shell
  bundle exec rails s
  ```
  And now you can visit the site with the URL http://localhost:3000

