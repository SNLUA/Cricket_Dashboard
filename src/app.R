library(shiny)
library(shinydashboard)

# UI
ui <- dashboardPage(
  dashboardHeader(title = "TVK Cricket Practice"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Setup", tabName = "setup", icon = icon("wrench")),
      menuItem("Data Entry", tabName = "data_entry", icon = icon("edit")),
      menuItem("Report", tabName = "report", icon = icon("chart-bar"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "setup",
              fluidRow(
                column(width = 4,
                       dateInput(inputId = "practice_date", label = "Date of practice")),
                column(width = 4,
                       textInput(inputId = "batsman_name", label = "Batsman name")),
                column(width = 4,
                       numericInput(inputId = "num_bowlers", label = "Number of bowlers", value = 1)),
                column(width = 4,
                       actionButton(inputId = "configure_btn", label = "Configure"))
              ),
              uiOutput("bowler_inputs"),
              fluidRow(
                column(width = 4,
                       actionButton(inputId = "done_btn", label = "Done"))
              )
      ),
      tabItem(tabName = "data_entry",
              # content for Data Entry tab goes here
      ),
      tabItem(tabName = "report",
              # content for Report tab goes here
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Generate bowler inputs dynamically based on number of bowlers
  observeEvent(input$configure_btn, {
    output$bowler_inputs <- renderUI({
      num_bowlers <- input$num_bowlers
      bowler_inputs <- list()
      for (i in 1:num_bowlers) {
        bowler_inputs[[i]] <- fluidRow(
          column(width = 4,
                 textInput(inputId = paste0("bowler_name_", i),
                           label = paste0("Bowler ", i, " name"))),
          column(width = 4,
                 selectInput(inputId = paste0("ball_type_", i),
                             label = paste0("Bowler ", i, " ball type"),
                             choices = c("New Ball", "Semi New Ball", "Old Ball")))
        )
      }
      do.call(tagList, bowler_inputs)
    })
  })
  
  # Assign values to variables on Done button click
  observeEvent(input$done_btn, {
    practice_date <- input$practice_date
    batsman_name <- input$batsman_name
    num_bowlers <- input$num_bowlers
    bowler_names <- list()
    ball_types <- list()
    for (i in 1:num_bowlers) {
      bowler_names[[i]] <- input[[paste0("bowler_name_", i)]]
      ball_types[[i]] <- input[[paste0("ball_type_", i)]]
    }
    assign("practice_date", practice_date, envir = .GlobalEnv)
    assign("batsman_name", batsman_name, envir = .GlobalEnv)
    assign("num_bowlers", num_bowlers, envir = .GlobalEnv)
    assign("bowler_names", bowler_names, envir = .GlobalEnv)
    assign("ball_types", ball_types, envir = .GlobalEnv)
  })
}

# Run the app
shinyApp(ui = ui, server = server)
