//
//  TodoListView.swift
//  VoiceMemo
//
//  Created by 현유진 on 8/11/25.
//

import SwiftUI

struct TodoListView: View {
  @EnvironmentObject private var pathModel: PathModel
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  @EnvironmentObject private var homeViewModel: HomeViewModel
  
  var body: some View {
    ZStack {
      VStack {
        if !todoListViewModel.todos.isEmpty {
          CustomNavigationBar(
            isDisplayLeftButton: false,
            rightButtonAction: {
              todoListViewModel.navigationRightButtonTapped()
            },
            rightButtonType: todoListViewModel.navigationBarRightButtonMode
          )
        } else {
          Spacer()
            .frame(height: 30)
        }
        
        TitleView()
          .padding(.top, 20)
        
        if todoListViewModel.todos.isEmpty {
          AnnouncementView()
        } else {
          TodoListContentView()
            .padding(.top, 20)
        }
        
        WriteTodoButtonView()
          .padding(.trailing, 20)
          .padding(.bottom, 50)
      }
    }
    .alert(
      "To do list \(todoListViewModel.removeTodos.count)개 삭제하시겠습니까?",
      isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
    ) {
      Button("삭제", role: .destructive) {
        todoListViewModel.removeButtonTapped()
      }
      Button("취소", role: .cancel) { }
    }
    .onChange(of: todoListViewModel.todos) { _, todos in
      homeViewModel.setTodosCount(todos.count)
    }
  }
}

// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  
  var body: some View {
    HStack {
      if todoListViewModel.todos.isEmpty {
        Text("To do list를\n추가해보세요.")
      } else {
        Text("To do list \(todoListViewModel.todos.count)개가\n있습니다.")
      }
      
      Spacer()
    }
    .font(.system(size: 30, weight: .bold))
    .padding(.leading, 30)
  }
}

// MARK: - TodoList 안내 뷰
private struct AnnouncementView: View {
  var body: some View {
    VStack(spacing: 15) {
      Spacer()
      
      Image("pencil")
        .renderingMode(.template)
      
      VStack(spacing: 8) {
        Text(" \"매일 아침 8시 운동가라고 알려줘\" ")
        Text(" \"내일 8시 수강 신청하라고 알려줘\" ")
        Text("\"1시 반 점심약속 리마인드 해줘\" ")
      }
    }
    .font(.system(size: 16))
    .foregroundColor(.customGray2)
  }
}

// MARK: - TodoList 컨텐츠 뷰
struct TodoListContentView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("할일 목록")
        .font(.system(size: 16, weight: .bold))
      
      ScrollView(.vertical) {
        VStack {
          CustomDividerView(.customGray0)
          
          ForEach(todoListViewModel.todos, id: \.self) { todo in
            // TODO: - Todo 셀 뷰
            TodoListCellView(todo: todo)
          }
        }
      }
    }
    .padding(.leading, 20)
  }
}

struct TodoListCellView: View {
  @EnvironmentObject private var todoListViewModel: TodoListViewModel
  @State private var isRemoveSelected: Bool
  private var todo: Todo
  
  init(
    isRemoveSelected: Bool = false,
    todo: Todo
  ) {
    self.todo = todo
    _isRemoveSelected = State(initialValue: isRemoveSelected)
  }
  
  var body: some View {
    VStack(spacing: 20) {
      HStack(spacing: 10) {
        if !todoListViewModel.isEditTodoMode {
          Button (
            action: {
              todoListViewModel.selectedBoxTapped(todo)
            },
            label: {
              todo.selected ? Image("selectedBox") : Image("unSelectedBox")
            }
          )
        }
        
        VStack(alignment: .leading, spacing: 5) {
          Text(todo.title)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(todo.selected ? .customIconGray : .customBlack)
            .strikethrough(todo.selected ? true : false)
          
          Text(todo.convertedDayAndTime)
            .font(.system(size: 12, weight: .regular))
            .foregroundColor(.customIconGray)
        }
        
        Spacer()
        
        if todoListViewModel.isEditTodoMode {
          Button (
            action: {
              isRemoveSelected.toggle()
              todoListViewModel.todoRemoveSelectedBoxTapped(todo)
            },
            label: {
              isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
            }
          )
        }
      }
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    
    CustomDividerView(.customGray0)
  }
}

// MARK: - 투두 생성 버튼 뷰
private struct WriteTodoButtonView: View {
  @EnvironmentObject private var pathModel: PathModel
  
  fileprivate var body: some View {
    VStack {
      Spacer()
      
      HStack {
        Spacer()
        
        Button(
          action: {
            pathModel.paths.append(.todoView)
          },
          label: {
            Image("writeBtn")
          }
        )
      }
    }
  }
}


#Preview {
  TodoListView()
    .environmentObject(TodoListViewModel())
    .environmentObject(PathModel())
}
