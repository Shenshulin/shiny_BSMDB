server <- function(input, output) {
  
  # 定义响应式变量，用于存储搜索结果和柱形图
  search_result <- reactiveVal(met)
  bar_plot <- reactiveVal()
  ms2_plot <- reactiveVal()
  
  # 当点击搜索按钮时，执行搜索操作
  observeEvent(input$search_btn, {
    code <- input$code_input
    if (code != "") {
      result <- met[met$Code == code, ]#设置搜索条件
      search_result(result)
      
      # 绘制ms2图
      file_path <- paste0("https://github.com/Shenshulin/shiny_BSMDB/tree/main/app_mdb/ms2/", result$Code, ".csv")
      if (file.exists(file_path)) {
        new_data <- read.csv(file_path)
        p <- ggplot(new_data, aes(x = x, y = y)) + 
          geom_col(width = 0.2,fill = "black") + 
          xlab("mz") + 
          ylab("intensity") +
          ggtitle("ms2图") +
          scale_x_continuous(limits = c(0, max(new_data$x+30)), expand = c(0, 0),
                             breaks = seq(0, 200, by = 50))+
          geom_text_repel(aes(label = x), size = 8)+
          theme(axis.text.x = element_text(size = 20),
                axis.text.y = element_text(size = 20)
          )
        ms2_plot(p)
      } else {
        ms2_plot(NULL)
      }
      
      # 绘制柱形图
      p2 <- ggplot() + 
        geom_bar(data = result, aes(x = "Bra", y = Bra), stat = "identity", fill = "#222449") +
        geom_bar(data = result, aes(x = "Bni", y = Bni), stat = "identity", fill = "#414C87") +
        geom_bar(data = result, aes(x = "Bol", y = Bol), stat = "identity", fill = "#9CB3D4") +
        geom_bar(data = result, aes(x = "Bju", y = Bju), stat = "identity", fill = "#F7E2DB") +
        geom_bar(data = result, aes(x = "Bna", y = Bna), stat = "identity", fill = "#AF5A76") +
        geom_bar(data = result, aes(x = "Bca", y = Bca), stat = "identity", fill = "#D2CED2")+
        theme(axis.text.x = element_text(size = 20),
              axis.text.y = element_text(size = 10))+
        labs(title = "各物种相对含量", x = "code", y = "value")
      bar_plot(p2)
      
    } else {
      search_result(met)#查询值为空时返回所有数据
      bar_plot(NULL)
      ms2_plot(NULL)
    }
  })
  
  # 显示搜索结果表格
  output$result_table <- renderTable({
    search_result()
  })
  
  # 显示ms2图
  output$ms2_plot <- renderPlot({
    ms2_plot()
  })
  
  # 显示柱形图
  output$bar_plot <- renderPlot({
    bar_plot()
  })
  
  # 显示图片
  output$image_output <- renderImage({
    result <- search_result()
    if (!is.null(result)) {
      file_path <- paste0("https://github.com/Shenshulin/shiny_BSMDB/tree/main/app_mdb/images/", result$Code, ".png")
      if (file.exists(file_path)) {
        list(src = file_path, contentType = "image/png", width = "50%")
      } else {
        NULL
      }
    }
  }, deleteFile = FALSE)
}
