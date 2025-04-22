module TODO.Admin.Index where

import Lucid
import TODO.Prelude
import TODO.Type.User

adminIndex :: Html ()
adminIndex = html_ $ do
  head_ $ do
    title_ "Admin Dashboard"
    style_ css
  body_ $ do
    div_ [class_ "container"] $ do
      nav_ [class_ "sidebar"] $ do
        h2_ "メニュー"
        ul_ $ do
          li_ $ a_ [href_ "/admin/tables"] "📋 DB テーブル一覧"
          li_ $ a_ [href_ "/admin/users"] "👤 登録ユーザー一覧"
      main_ [class_ "content"] $ do
        h1_ "管理画面へようこそ"
        p_ "左のメニューから操作を選んでください。"

css :: Text
css =
  unlines
    [ ".container { display: flex; height: 100vh; font-family: sans-serif; }",
      ".sidebar { width: 250px; background: #f5f5f5; padding: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }",
      ".content { flex: 1; padding: 20px; }",
      "ul { list-style: none; padding: 0; }",
      "li { margin: 10px 0; }",
      "a { text-decoration: none; color: #333; font-weight: bold; }",
      "a:hover { color: #007acc; }"
    ]

renderUserRow :: User -> Html ()
renderUserRow (User uid un) = tr_ $ do
  td_ (toHtml $ toText uid)
  td_ (toHtml un)

renderUserList :: [User] -> Html ()
renderUserList users = html_ $ do
  head_ $ title_ "ユーザー一覧"
  body_ $ do
    h1_ "登録ユーザー一覧"
    table_ $ do
      thead_ $ tr_ $ do
        th_ "ID"
        th_ "名前"
      tbody_ $ mapM_ renderUserRow users
