import { createFileRoute } from '@tanstack/react-router';
import { TodoList } from '@/components/TodoList';
import { AddTodoForm } from '@/components/AddTodoForm';
import { TodoSummary } from '@/components/TodoSummary';
import {
  useCreateTodo,
  useDeleteTodo,
  useTodos,
  useUpdateStatus,
} from '@/hooks/api/todo';
import { useSnackbar } from '@/contexts/SnackBarContext';
import { useEffect } from 'react';

function TodoIndex() {
  const { data: todoList } = useTodos();
  const { mutate: createTodo } = useCreateTodo();
  const { mutate: deleteTodo } = useDeleteTodo();
  const { mutate: updateStatus } = useUpdateStatus();

  return (
    <div className="space-y-5">
      <AddTodoForm addTodo={createTodo} />
      <div className="space-y-5 rounded bg-slate-200 p-5">
        <TodoList
          todoList={todoList ?? []}
          changeCompleted={updateStatus}
          deleteTodo={deleteTodo}
        />
        <TodoSummary
          deleteAllCompleted={() => {
            return;
          }}
        />
      </div>
    </div>
  );
}

function TodoPage() {
  const { lastMessage, lastType, showSnackbar } = useSnackbar();

  useEffect(() => {
    if (lastMessage && lastType) {
      showSnackbar(lastMessage, lastType); // 保存されたメッセージを表示
    }
  }, [lastMessage, lastType, showSnackbar]);

  return (
    <main className="max-w-screen-md mx-auto">
      <h1 className="text-center text-4xl">Todoアプリ</h1>
      <TodoIndex />
    </main>
  );
}

export const Route = createFileRoute('/todo/')({
  component: () => <TodoPage />,
});
