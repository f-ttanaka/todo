module TODO.Pages.Admin.Index (adminIndex) where

import Lucid
import TODO.Prelude

adminIndex :: Html ()
adminIndex = html_ $ do
  head_ $ do
    title_ "Admin Dashboard"
    meta_ [charset_ "utf-8"]
    meta_ [name_ "viewport", content_ "width=device-width, initial-scale=1"]
    -- Tailwind CSS を CDN 経由で読み込み
    link_ [rel_ "stylesheet", href_ "https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"]
  body_ [class_ "h-screen font-sans"] $ do
    div_ [class_ "flex h-full"] $ do
      nav_ [class_ "w-64 bg-gray-100 p-6 shadow-md"] $ do
        h2_ [class_ "text-xl font-semibold mb-4"] "メニュー"
        ul_ [class_ "space-y-2"] $ do
          li_ $ a_ [href_ "/admin/tables", class_ "block text-gray-800 font-bold hover:text-blue-600"] "📋 DB テーブル一覧"
      -- li_ $ a_ [href_ "/admin/users", class_ "block text-gray-800 font-bold hover:text-blue-600"] "👤 登録ユーザー一覧"
      main_ [class_ "flex-1 p-8 bg-white"] $ do
        h1_ [class_ "text-2xl font-bold mb-4"] "管理画面へようこそ"
        p_ [class_ "text-gray-700"] "左のメニューから操作を選んでください。"
