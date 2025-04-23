import { useState } from 'react';
import { Plus } from 'lucide-react';

type Props = {
  addTodo: (title: string) => void;
};

export const AddTodoForm = ({ addTodo }: Props) => {
  const [inputValue, setInputValue] = useState('');
  const isGoogleConnected = false;

  const onSubmit = () => {
    addTodo(inputValue);

    setInputValue('');
  };

  return (
    <>
      <form
        className="flex"
        // +ボタンをクリックすると発火
        onSubmit={onSubmit}
      >
        <input
          type="text"
          placeholder="新しいTodoを入力してください"
          className="grow rounded-s bg-slate-200 p-2"
          value={inputValue}
          onChange={(e) => setInputValue(e.target.value)}
        />
        <button
          type="submit"
          className="rounded-e bg-blue-600 p-2 transition-colors hover:bg-blue-800 disabled:bg-gray-400"
          disabled={!inputValue}
        >
          <Plus className="text-white" />
        </button>
      </form>
      {!isGoogleConnected && (
        <div className="mb-4">
          <p className="text-sm text-gray-600">
            位置情報を使うには Google アカウントの連携が必要です。
          </p>
          <button
            // onClick={handleGoogleConnect}
            className="mt-2 rounded bg-red-500 px-3 py-1 text-white hover:bg-red-600"
          >
            Google と連携する
          </button>
        </div>
      )}
    </>
  );
};
