library(tidyverse)
library(ggplot2)
library(ggrepel)
library(httr)
url <- "https://github.com/Shenshulin/shiny_BSMDB/tree/main/app_mdb/met_inf.csv"
response <- GET(url)
data <- content(response, "text")
# 定义UI界面
met <- read.csv(text = data) # 添加文件路径参数，并禁用字符串因子
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
        tabPanel("含量柱形图", plotOutput("bar_plot")),
        tabPanel("化学式", imageOutput("image_output"))
      )
    )
  )
)