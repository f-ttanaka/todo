module TODO.Query.Todo where

import Data.Profunctor (rmap)
import qualified Data.Vector as Vec
import Hasql.Statement (Statement)
import qualified Hasql.TH as TH
import TODO.Prelude
import TODO.Type.Todo

fetchAll :: Statement () [Todo]
fetchAll = rmap (Vec.toList . fmap decode) query
  where
    query =
      [TH.vectorStatement|
        select
          uuid :: uuid
					, user_uuid :: uuid
          , title :: text
          , completed :: boolean
        from todos
      |]
    decode (u, uu, t, c) = Todo u uu t c

deleteById :: Statement UUID Int
deleteById = rmap fromIntegral query
  where
    query =
      [TH.rowsAffectedStatement|
        delete from todos
        where
          uuid = $1 :: uuid
      |]

insertOne :: Statement Text UUID
insertOne = query
  where
    query =
      [TH.singletonStatement|
        insert into
          todos (title, completed)
          values ($1 :: text, false)
        returning uuid :: uuid
      |]

updateTitle :: Statement (UUID, Text) ()
updateTitle = query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set title = $2 :: text
        where uuid = $1 :: uuid
      |]

updateStatus :: Statement UUID ()
updateStatus = query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set completed = not completed
        where uuid = $1 :: uuid
      |]
