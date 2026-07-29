-- user_id	account_id	email
-- 371	144	staging@venuepilot.co
-- 244	105	venuepilotstaging@gmail.com

-- staging event 53825
-- venuepilotstaging event 35692


-- select id, name, payment_id, payment_key from accounts where id = 105
-- select id, account_id from users where email like '%authorize%'
-- select id, name, payment_id, payment_key, stripe_api_key, stripe_publishable_key from accounts where stripe_publishable_key is not null
-- select id, name, status, account_id from events where name like '%Leo Test%'
-- select * from events where name like '%Leo Test%'
-- select id, name from accounts where name like '%Staging%'
-- update accounts set payment_id = '22mjYBC2Za', payment_key = '29nMt22j2V4z65Zq' where id = 144
-- update accounts set stripe_api_key = null, stripe_publishable_key = 'pk_test_5mKRgHGEA14JFNLagukdPQbC' where id = 105
-- select account_id, use_ticket_locking from events where id = 35692
-- select email from users where account_id = 105
-- update events set use_ticket_locking = false where id = 35692
-- select stripe_publishable_key from accounts where id = 105

