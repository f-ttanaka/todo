module TODO.Query.Todo
  ( fetchAll,
    deleteById,
    insertOne,
    updateTitle,
    updateStatus,
  )
where

import Data.Profunctor (rmap)
import qualified Data.Vector as Vec
import Hasql.Statement (Statement)
import qualified Hasql.TH as TH
import TODO.Prelude
import TODO.Type.Todo

fetchAll :: Statement UUID [Todo]
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
        where 
          user_uuid = $1 :: uuid
      |]
    decode (u, uu, t, c) = Todo u uu t c

deleteById :: Statement (UUID, UUID) Int
deleteById = rmap fromIntegral query
  where
    query =
      [TH.rowsAffectedStatement|
        delete from todos
        where
          user_uuid = $1 :: uuid
          and uuid = $2 :: uuid
      |]

insertOne :: Statement (UUID, Text) UUID
insertOne = query
  where
    query =
      [TH.singletonStatement|
        insert into
          todos (
            user_uuid,
            title,
            completed)
          values (
            $1 :: uuid,
            $2 :: text, 
            false)
        returning uuid :: uuid
      |]

updateTitle :: Statement (UUID, UUID, Text) ()
updateTitle = query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set title = $3 :: text
        where user_uuid = $1 :: uuid
        and uuid = $2 :: uuid
      |]

updateStatus :: Statement (UUID, UUID) ()
updateStatus = query
  where
    query =
      [TH.resultlessStatement|
        update todos
          set completed = not completed
        where user_uuid = $1 :: uuid
        and uuid = $2 ::uuid
      |]
