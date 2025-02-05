module TODO.Query.User where

import Data.Profunctor (lmap, rmap)
import Hasql.Statement (Statement)
import qualified Hasql.TH as TH
import TODO.Lib.Crypt
import TODO.Prelude
import TODO.Type.User

-- fetchByUuid :: UUID -> IO (Maybe User)
-- fetchByUuid ui = createSession $ Session.statement ui $ rmap (fmap decode) query
--   where
--     query =
--       [TH.maybeStatement|
--         select
--           uuid :: uuid
--           , name :: text
--         from todos
-- 				where uuid = $1 :: uuid
--       |]
--     decode (u, n) = User u n

-- return user and password hash
fetchByName :: Statement Text (Maybe (User, Text))
fetchByName = rmap (fmap decode) query
  where
    query =
      [TH.maybeStatement|
        select
          uuid :: uuid
          , name :: text
					, password :: text
        from todos
				where name = $1 :: text
      |]
    decode (u, n, p) = (User u n, p)

insert :: Statement UserOnSave UUID
insert = lmap encode query
  where
    encode (UserOnSave n p) = (n, hashedText p)
    query =
      [TH.singletonStatement|
        insert into
          users (name, password)
          values ($1 :: text, $2 :: text)
        returning uuid :: uuid
      |]
