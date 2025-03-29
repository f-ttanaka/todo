import { createContext, useContext, useState, ReactNode } from 'react';

type SnackbarType = 'success' | 'error' | 'info' | 'warning';

interface SnackbarContextType {
  message: string;
  type: SnackbarType;
  showSnackbar: (
    message: string,
    type: SnackbarType,
    persist?: boolean,
  ) => void;
  hideSnackbar: () => void;
  lastMessage: string | null; // 新しく追加
  lastType: SnackbarType | null;
}

const SnackbarContext = createContext<SnackbarContextType | undefined>(
  undefined,
);

export const useSnackbar = () => {
  const context = useContext(SnackbarContext);
  if (!context) {
    throw new Error('useSnackbar must be used within a SnackbarProvider');
  }
  return context;
};

export const SnackbarProvider = ({ children }: { children: ReactNode }) => {
  const [message, setMessage] = useState('');
  const [type, setType] = useState<SnackbarType>('info');
  const [lastMessage, setLastMessage] = useState<string | null>(null);
  const [lastType, setLastType] = useState<SnackbarType | null>(null);

  const showSnackbar = (
    msg: string,
    snackbarType: SnackbarType,
    persist: boolean = false,
  ) => {
    if (persist) {
      setLastMessage(msg);
      setLastType(snackbarType);
    } else {
      setMessage(msg);
      setType(snackbarType);
      setTimeout(() => setMessage(''), 3000);
    }
  };

  const hideSnackbar = () => setMessage('');

  return (
    <SnackbarContext.Provider
      value={{
        message,
        type,
        showSnackbar,
        hideSnackbar,
        lastMessage,
        lastType,
      }}
    >
      {children}
      <Snackbar />
    </SnackbarContext.Provider>
  );
};

// スナックバー UI コンポーネント
const Snackbar = () => {
  const { message, type, hideSnackbar } = useSnackbar();

  if (!message) return null;

  return (
    <div
      className={`fixed bottom-5 left-1/2 transform -translate-x-1/2 px-4 py-2 rounded shadow-lg text-white ${
        type === 'success'
          ? 'bg-green-500'
          : type === 'error'
            ? 'bg-red-500'
            : type === 'warning'
              ? 'bg-yellow-500'
              : 'bg-blue-500'
      }`}
    >
      {message}
      <button onClick={hideSnackbar} className="ml-4 text-white font-bold">
        ✕
      </button>
    </div>
  );
};
