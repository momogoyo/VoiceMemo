//
//  TodoView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct TodoView: View {
  /// @EnvironmentObject - 외부 주입을 기다림 - 주입 필수, 데이터 공유가 목적(여러 뷰가 같은 인스턴스를 공유로 데이터 동기화)
  @EnvironmentObject var pathModel: PathModel
  @EnvironmentObject var todoListViewModel: TodoListViewModel
  /// @StateObject - 내부에서 직접 생성 - 주입 불필요
  @StateObject private var todoViewModel: TodoViewModel = TodoViewModel()
  
  var body: some View {
    VStack {
      CustomNavigationBar(
        leftButtonAction: {
          pathModel.paths.removeLast()
        },
        rightButtonAction: {
          todoListViewModel.addTodo(
            Todo.init(
              title: todoViewModel.title,
              time: todoViewModel.time,
              day: todoViewModel.day,
              selected: false
            )
          )
          
          pathModel.paths.removeLast()
        },
        rightButtonType: .create
      )
      
      TitleView()
        .padding(.top, 20)
      
      Spacer()
        .frame(height: 20)
      
      TodoTitleView(todoViewModel: todoViewModel)
        .padding(.leading, 20)
      
      SelectTimeView(todoViewModel: todoViewModel)
      
      SelectDayView(todoViewModel: todoViewModel)
        .padding(.leading, 20)
      
      Spacer()
    }
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
  fileprivate var body: some View {
    HStack {
      Text("To do list를\n추가해 보세요.")
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 20)
      
      Spacer()
    }
    
  }
}

// MARK: - 투두 타이틀 뷰 (제목 입력)
private struct TodoTitleView: View {
  @ObservedObject private var todoViewModel: TodoViewModel
  
  fileprivate init(todoViewModel: TodoViewModel) {
    self.todoViewModel = todoViewModel
  }
  
  fileprivate var body: some View {
    TextField(
      "제목을 입력하세요.",
      text: $todoViewModel.title
    )
  }
}

// MARK: - 시간 선택 뷰
private struct SelectTimeView: View {
  @ObservedObject private var todoViewModel: TodoViewModel
  
  fileprivate init(todoViewModel: TodoViewModel) {
    self.todoViewModel = todoViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      CustomDividerView(.customCoolGray)
      
      DatePicker(
        "시간 선택",
        selection: $todoViewModel.time,
        displayedComponents: .hourAndMinute
      )
      .labelsHidden()
      .datePickerStyle(WheelDatePickerStyle())
      .environment(\.locale, Locale(identifier: "ko"))
      .frame(maxWidth: .infinity, alignment: .center)

      CustomDividerView(.customCoolGray)
    }
    
  }
}

// MARK: - 날짜 선택 뷰
private struct SelectDayView: View {
  @ObservedObject private var todoViewModel: TodoViewModel
  
  fileprivate init(todoViewModel: TodoViewModel) {
    self.todoViewModel = todoViewModel
  }
  
  fileprivate var body: some View {
    VStack {
      HStack {
        Text("날짜")
          .foregroundColor(.customIconGray)
        
        Spacer()
      }
      
      HStack {
        Button(
          action: {
            todoViewModel.setDisplayCalendar(true)
          },
          label: {
            Text("\(todoViewModel.day.formattedDay)")
              .font(.system(size: 18, weight: .medium))
              .foregroundStyle(.customGreen)
          }
        )
        .popover(isPresented: $todoViewModel.isDisplayCalendar) {
          DatePicker(
            "",
            selection: $todoViewModel.day,
            displayedComponents: .date
          )
          .labelsHidden()
          .datePickerStyle(.graphical)
          .environment(\.locale, Locale(identifier: "ko"))
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
          .onChange(of: todoViewModel.day){
            todoViewModel.setDisplayCalendar(false)
          }
        }
        
        Spacer()
      }
    }
    
  }
}

#Preview {
  TodoView()
}
