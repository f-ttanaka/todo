import { Todo } from '@/types/todo';
import { Trash2 } from 'lucide-react';
import { useState } from 'react';
import { TodoDetailModal } from '@/components/todo/TodoDetailModal';

type Props = {
  todoList: Todo[];
  changeCompleted: (uuid: string) => void;
  deleteTodo: (uuid: string) => void;
};

export const TodoList = ({ todoList, changeCompleted, deleteTodo }: Props) => {
  const [selectedTodo, setSelectedTodo] = useState<Todo | null>(null);
  return (
    <>
      <div className="space-y-3">
        {todoList.map((todo) => (
          <div
            key={todo.uuid}
            className="flex items-center gap-3 rounded bg-white p-2"
          >
            <label className="flex grow items-center gap-3 hover:cursor-pointer">
              <div className="flex items-center">
                <input
                  type="checkbox"
                  className="size-5"
                  checked={todo.completed}
                  onChange={() => changeCompleted(todo.uuid)}
                />
              </div>
              {/* completedがtrueならクラスを適用、falseならクラスを適用しない */}
              <span
                className={todo.completed ? 'text-gray-400 line-through' : ''}
              >
                {todo.title}
              </span>
            </label>

            <div className="flex items-center gap-2">
              <button
                type="button"
                className="rounded bg-blue-100 px-3 py-1 text-sm text-blue-700 transition-colors hover:bg-blue-200"
                onClick={() => setSelectedTodo(todo)}
              >
                詳細を開く
              </button>
              <button
                type="button"
                className="rounded bg-gray-200 p-2 transition-colors hover:bg-gray-300"
                onClick={() => deleteTodo(todo.uuid)}
              >
                <Trash2 className="size-5 text-gray-500" />
              </button>
            </div>
          </div>
        ))}
        {/* Todoが無い場合、表示する */}
        {todoList.length === 0 && (
          <p className="text-center text-sm">Todoがありません</p>
        )}
      </div>

      <TodoDetailModal
        todo={selectedTodo}
        onClose={() => setSelectedTodo(null)}
      />
    </>
  );
};
