import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_remind/data/model/todo.dart';
import 'package:flutter_todo_remind/ui/home/home_view_model.dart';
import 'package:flutter_todo_remind/ui/home/todo_item.dart';

// 투두리스트 파이어스토어에서 가져와야하는 시점
// => HomePage 들어왔을 때 최초 한번!
class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) 뷰모델 관리자한테 상태 달라고 하기
    final homeState = ref.watch(homeViewModelProvider);
    // 2) 뷰모델 관리자한테 뷰모델 달라고 하기
    final homeViewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Color(0xFF5714E6),
        foregroundColor: Colors.white,
        onPressed: () {
          // TODO 키보드 가리기
          showModalBottomSheet(
            context: context,
            builder: (context) {
              String content = "";
              return Container(
                height: 300,
                width: double.infinity,
                padding: EdgeInsets.only(left: 24, right: 24, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 할일 글자
                    Text('할일'),
                    SizedBox(height: 11),
                    // 글자 입력하는 테스트필드
                    TextField(
                      onChanged: (value) {
                        content = value;
                      },
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F2024),
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xFF1414E6),
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    // 저장 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          homeViewModel.writeTodo(content);
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            Color(0xFF5714E6),
                          ),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
      appBar: AppBar(
        title: Text(
          'TODO 리스트',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1),
          child: Container(
            height: 1,
            // FF => 255
            // 불투명도 0~255
            // 0x00
            color: Color(0xFFDCDCDC),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.separated(
          itemBuilder: (context, index) {
            Todo todo = homeState[index];
            // { "isDone" : false, "content" : "hi", "id" : "dsaklfjlaskfjalsk" }
            print(todo);

            return TodoItem(
              onCheckTap: () async {
                print("여기서 체크 변경!");
                homeViewModel.updateTodo(todo);
              },
              isChecked: todo.isDone,
              text: todo.content,
              onDelete: () async {
                homeViewModel.deleteTodo(todo);
              },
              onEdit: () {},
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10);
          },
          itemCount: homeState.length,
        ),
      ),
    );
  }
}
