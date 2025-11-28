CREATE TRIGGER create_profile_for_new
BEFORE INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION create_profile_for_new();

CREATE TRIGGER create_notification_for_new
AFTER INSERT ON auth.users
FOR EACH ROW
EXECUTE FUNCTION create_notification_for_new();
