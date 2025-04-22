module TODO.Pages.Admin.Users
  ( renderUserList,
    renderNewUserForm,
  )
where

import Lucid
import TODO.Data.User
import TODO.Prelude hiding (for_)

-- 一覧ページ
renderUserList :: [User] -> Html ()
renderUserList users = html_ $ do
  head_ $ do
    title_ "ユーザー一覧"
    meta_ [charset_ "utf-8"]
    meta_ [name_ "viewport", content_ "width=device-width, initial-scale=1"]
    link_ [rel_ "stylesheet", href_ "https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"]
  body_ [class_ "bg-gray-100 min-h-screen flex items-center justify-center"] $ do
    div_ [class_ "w-full max-w-4xl bg-white shadow-md rounded p-6"] $ do
      div_ [class_ "flex justify-between items-center mb-4"] $ do
        h1_ [class_ "text-2xl font-bold"] "登録ユーザー一覧"
        a_ [href_ "/admin/users/new", class_ "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"] "＋ 新規ユーザー登録"
      table_ [class_ "table-auto w-full border-collapse"] $ do
        thead_ $ tr_ $ do
          th_ [class_ "border-b-2 px-4 py-2 text-left"] "ID"
          th_ [class_ "border-b-2 px-4 py-2 text-left"] "名前"
        tbody_ $ mapM_ renderUserRow users
  where
    renderUserRow :: User -> Html ()
    renderUserRow (User uid un) = tr_ $ do
      td_ [class_ "border px-4 py-2"] (toHtml $ toText uid)
      td_ [class_ "border px-4 py-2"] (toHtml un)

-- ユーザー新規作成ページ
renderNewUserForm :: Html ()
renderNewUserForm = html_ $ do
  head_ $ do
    title_ "ユーザー登録"
    meta_ [charset_ "utf-8"]
    meta_ [name_ "viewport", content_ "width=device-width, initial-scale=1"]
    link_ [rel_ "stylesheet", href_ "https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"]
  body_ [class_ "bg-gray-100 min-h-screen flex items-center justify-center"] $ do
    div_ [class_ "w-full max-w-md bg-white shadow-md rounded p-6"] $ do
      h1_ [class_ "text-2xl font-bold mb-4"] "新規ユーザー登録"
      form_ [method_ "post", action_ "/admin/users/new"] $ do
        div_ [class_ "mb-4"] $ do
          label_ [for_ "name", class_ "block text-gray-700 font-bold mb-2"] "名前"
          input_ [type_ "text", id_ "name", name_ "name", required_ "", class_ "w-full border rounded px-3 py-2"]
        div_ [class_ "flex justify-between items-center"] $ do
          a_ [href_ "/admin/users", class_ "text-blue-500 hover:underline"] "← ユーザー一覧へ戻る"
          button_ [type_ "submit", class_ "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"] "登録する"
