import type { Todo } from '@/types/todo';

type Props = {
  todo: Todo | null;
  onClose: () => void;
};

export function TodoDetailModal({ todo, onClose }: Props) {
  if (!todo) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-30">
      <div className="w-full max-w-md rounded bg-white p-6 shadow-lg">
        <h2 className="mb-4 text-xl font-semibold">Todoの詳細</h2>
        <p>
          <strong>タイトル:</strong> {todo.title}
        </p>
        <p>
          <strong>完了:</strong> {todo.completed ? '✅ 完了済み' : '❌ 未完了'}
        </p>

        <div className="mt-6 text-right">
          <button
            onClick={onClose}
            className="rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600"
          >
            閉じる
          </button>
        </div>
      </div>
    </div>
  );
}
