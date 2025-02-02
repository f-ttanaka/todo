module TODO.Query.Todo where

import Data.Profunctor (rmap)
import qualified Data.Vector as Vec
import qualified Hasql.Session as Session
import qualified Hasql.TH as TH
import TODO.Prelude
import TODO.Query.Common (createSession)
import TODO.Type.Todo (Todo (..), UUID)

fetchAll :: IO [Todo]
fetchAll = createSession $ fmap Vec.toList $ Session.statement () $ rmap (fmap decode) query
  where
    query =
      [TH.vectorStatement|
        select
          uuid :: uuid
          , title :: text
          , completed :: boolean
        from todos
      |]
    decode (u, t, c) = Todo u t c

deleteById :: UUID -> IO Int
deleteById u = createSession $ fmap fromIntegral $ Session.statement u query
  where
    query =
      [TH.rowsAffectedStatement|
        delete from todos
        where
          uuid = $1 :: uuid
      |]

insertOne :: Text -> IO UUID
insertOne text = createSession $ Session.statement text query
  where
    query =
      [TH.singletonStatement|
        insert into
          todos (title, completed)
          values ($1 :: text, false)
        returning uuid :: uuid
      |]

updateTitle :: UUID -> Text -> IO ()
updateTitle u t = createSession $ Session.statement (u, t) query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set title = $2 :: text
        where uuid = $1 :: uuid
      |]

updateStatus :: UUID -> IO ()
updateStatus u = createSession $ Session.statement u query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set completed = not completed
        where uuid = $1 :: uuid
      |]
