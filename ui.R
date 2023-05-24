ui <- fluidPage(
  # 输入框和搜索按钮
  sidebarLayout(
    sidebarPanel(
      textInput("code_input", "请输入code："),
      actionButton("search_btn", "搜索")
    ),
    mainPanel(
      # 显示结果表格和柱形图
      tabsetPanel(
        tabPanel("查询结果", tableOutput("result_table")),
        tabPanel("ms2图", plotOutput("ms2_plot")),
        tabPanel("含量柱形图", plotOutput("bar_plot"))
      )
    )
  )
)
