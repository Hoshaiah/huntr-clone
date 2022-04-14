# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Card.destroy_all
KanbanColumn.destroy_all
Kanban.destroy_all
User.destroy_all

#create user
job_hunter = User.create(
    email: 'test@test.com', 
    password: '123456', 
    password_confirmation: '123456'
)

#create Kanban board
my_kanban = Kanban.create(
    name: "New Lamborgucci project",
    description: "Project to build the most esthetically car ever made.",
    user: job_hunter
)

#create column 1
backlog = KanbanColumn.create(
    name: "Backlog",
    kanban: my_kanban
)

#create sample cards for column 1
Card.create(content: "Build engine", position: 0, kanban_column: backlog)
Card.create(content: "Purchase the tires", position: 1, kanban_column: backlog)
Card.create(content: "Code the cockpit software", position: 2, kanban_column: backlog)

#create column 2
todo = KanbanColumn.create(
    name: "To Do",
    kanban: my_kanban
)

#create sample card for column 2
Card.create(content: "Design the car", position: 0, kanban_column: todo)

#create column 3
completed = KanbanColumn.create(
    name: "Completed",
    kanban: my_kanban
)

#create sample cards for column 3
Card.create(content: "Build the engineer team", position: 0, kanban_column: completed)
Card.create(content: "Find fundings", position: 1, kanban_column: completed)