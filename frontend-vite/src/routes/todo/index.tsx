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

function TodoIndex() {
  const { data: todoList } = useTodos();
  const { mutate: createTodo } = useCreateTodo();
  const { mutate: deleteTodo } = useDeleteTodo();
  const { mutate: updateStatus } = useUpdateStatus();
  return (
    <main className="max-w-screen-md mx-auto">
      <h1 className="text-center text-4xl">Todoアプリ</h1>
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
    </main>
  );
}

export const Route = createFileRoute('/todo/')({
  component: RouteComponent,
});

function RouteComponent() {
  return <TodoIndex />;
}
