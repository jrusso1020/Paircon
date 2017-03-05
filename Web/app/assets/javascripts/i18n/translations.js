var I18n = I18n || {};
I18n.translations = {
    "en": {
        "date": {
            "formats": {
                "default": "%d %b %Y",
                "short": "%B %Y",
                "long": "%e de %B de %Y",
                "text_field": "%m/%d/%Y",
                "display": "MM/DD/YYYY",
                "datepicker": "mm/dd/yy",
                "fullcalendar": {
                    "title_format": {
                        "month": "MMMM yyyy",
                        "week": "MMM d[ yyyy]{ '\u0026#8212;'[ MMM] d yyyy}",
                        "day": "dddd, MMM d, yyyy"
                    }, "column_format": {"month": "ddd", "week": "ddd M/d", "day": "dddd M/d"}
                }
            },
            "day_names": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
            "abbr_day_names": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            "month_names": [null, "January", "Feburary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
            "abbr_month_names": [null, "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            "order": ["day", "month", "year"]
        },
        "time": {
            "formats": {
                "default": "%I:%M %p",
                "short": "%I %p",
                "long": "%a, %d %b %Y %I:%M %p",
                "fullcalendar": {"axis_format": "h(:mm)tt", "time_format": "h:mm t{ - h:mm t} "}
            }, "am": "am", "pm": "pm"
        },
        "support": {
            "array": {
                "words_connector": ", ",
                "two_words_connector": " and ",
                "last_word_connector": ", and "
            }
        },
        "number": {
            "format": {
                "separator": ".",
                "delimiter": ",",
                "precision": 3,
                "significant": false,
                "strip_insignificant_zeros": false
            },
            "currency": {
                "format": {
                    "format": "%u%n",
                    "unit": "$",
                    "separator": ".",
                    "delimiter": ",",
                    "precision": 2,
                    "significant": false,
                    "strip_insignificant_zeros": false
                }
            },
            "percentage": {"format": {"delimiter": "", "format": "%n%"}},
            "precision": {"format": {"delimiter": ""}},
            "human": {
                "format": {"delimiter": "", "precision": 3, "significant": true, "strip_insignificant_zeros": true},
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                },
                "decimal_units": {
                    "format": "%n %u",
                    "units": {
                        "unit": "",
                        "thousand": "Thousand",
                        "million": "Million",
                        "billion": "Billion",
                        "trillion": "Trillion",
                        "quadrillion": "Quadrillion"
                    }
                }
            }
        },
        "errors": {
            "format": "%{attribute} %{message}",
            "messages": {
                "inclusion": "is not included in the list",
                "exclusion": "is reserved",
                "invalid": "is invalid",
                "confirmation": "doesn't match %{attribute}",
                "accepted": "must be accepted",
                "empty": "can't be empty",
                "blank": "can't be blank",
                "present": "must be blank",
                "too_long": {
                    "one": "is too long (maximum is 1 character)",
                    "other": "is too long (maximum is %{count} characters)"
                },
                "too_short": {
                    "one": "is too short (minimum is 1 character)",
                    "other": "is too short (minimum is %{count} characters)"
                },
                "wrong_length": {
                    "one": "is the wrong length (should be 1 character)",
                    "other": "is the wrong length (should be %{count} characters)"
                },
                "not_a_number": "is not a number",
                "not_an_integer": "must be an integer",
                "greater_than": "must be greater than %{count}",
                "greater_than_or_equal_to": "must be greater than or equal to %{count}",
                "equal_to": "must be equal to %{count}",
                "less_than": "must be less than %{count}",
                "less_than_or_equal_to": "must be less than or equal to %{count}",
                "other_than": "must be other than %{count}",
                "odd": "must be odd",
                "even": "must be even",
                "taken": "has already been taken",
                "in_between": "must be in between %{min} and %{max}",
                "spoofed_media_type": "has an extension that does not match its contents",
                "already_confirmed": "was already confirmed, please try signing in",
                "confirmation_period_expired": "needs to be confirmed within %{period}, please request a new one",
                "expired": "has expired, please request a new one",
                "not_found": "not found",
                "not_locked": "was not locked",
                "not_saved": {
                    "one": "1 error prohibited this %{resource} from being saved:",
                    "other": "%{count} errors prohibited this %{resource} from being saved:"
                }
            }
        },
        "activerecord": {
            "errors": {
                "messages": {
                    "record_invalid": "Validation failed: %{errors}",
                    "restrict_dependent_destroy": {
                        "one": "Cannot delete record because a dependent %{record} exists",
                        "many": "Cannot delete record because dependent %{record} exist"
                    },
                    "blank": "field cannot be left blank"
                },
                "models": {
                    "user": {
                        "attributes": {
                            "first_name": {"blank": "Enter your first name"},
                            "last_name": {"blank": "Enter your last name"},
                            "email": {
                                "blank": "Enter your email address",
                                "taken": "This email address is already in use",
                                "invalid": "Enter a valid email address",
                                "too_short": "Email is too short (minimum is %{count} characters)",
                                "too_long": "Email is too long (maximum is %{count} characters)"
                            }
                        }
                    },
                    "tag": {
                        "attributes": {
                            "name": {
                                "too_long": "Tag is too long (maximum is %{count} characters)",
                                "taken": "Tag already exists, please give a unique name"
                            }
                        }
                    }
                }
            },
            "attributes": {
                "user": {
                    "first_name": "First Name",
                    "last_name": "Last Name",
                    "full_name": "Full Name",
                    "email": "Email",
                    "password": "Password",
                    "password_confirmation": "Retype Password"
                }
            }
        },
        "datetime": {
            "distance_in_words": {
                "half_a_minute": "half a minute",
                "less_than_x_seconds": {"one": "less than 1 second", "other": "less than %{count} seconds"},
                "x_seconds": {"one": "1 second", "other": "%{count} seconds"},
                "less_than_x_minutes": {"one": "less than a minute", "other": "less than %{count} minutes"},
                "x_minutes": {"one": "1 minute", "other": "%{count} minutes"},
                "about_x_hours": {"one": "about 1 hour", "other": "about %{count} hours"},
                "x_days": {"one": "1 day", "other": "%{count} days", "zero": "0 day"},
                "about_x_months": {"one": "about 1 month", "other": "about %{count} months"},
                "x_months": {"one": "1 month", "other": "%{count} months"},
                "about_x_years": {"one": "about 1 year", "other": "about %{count} years"},
                "over_x_years": {"one": "over 1 year", "other": "over %{count} years"},
                "almost_x_years": {"one": "almost 1 year", "other": "almost %{count} years"}
            },
            "prompts": {
                "year": "Year",
                "month": "Month",
                "day": "Day",
                "hour": "Hour",
                "minute": "Minute",
                "second": "Seconds"
            }
        },
        "helpers": {
            "select": {"prompt": "Please select"},
            "submit": {"create": "Create %{model}", "update": "Update %{model}", "submit": "Save %{model}"}
        },
        "flash": {
            "actions": {
                "create": {"notice": "%{resource_name} was successfully created."},
                "update": {"notice": "%{resource_name} was successfully updated."},
                "destroy": {
                    "notice": "%{resource_name} was successfully destroyed.",
                    "alert": "%{resource_name} could not be destroyed."
                }
            }
        },
        "devise": {
            "confirmations": {
                "confirmed": "Your account was successfully confirmed. Please proceed and login with your credentials.",
                "send_instructions": "You will receive an email with instructions about how to confirm your account in a few minutes. Please check your Junk folder as your mail could have been marked as spam.",
                "send_paranoid_instructions": "If your email address exists in our database, you will receive an email with instructions about how to confirm your account in a few minutes."
            },
            "failure": {
                "already_authenticated": "",
                "inactive": "Your account is inactive or your payment is outstanding. To continue use of the service please ask the account owner of your company to log in and make your account active or complete the billing information.",
                "invalid": "Invalid email or password. Please try again ...",
                "locked": "Your account is locked.",
                "last_attempt": "You have one more attempt before your account is locked.",
                "not_found_in_database": "Invalid email or password. Please try again ...",
                "timeout": "",
                "unauthenticated": "",
                "unconfirmed": "This email is pending for verification.\n If you wish to resend email verification click ",
                "invalid_token": "Invalid authentication token."
            },
            "mailer": {
                "confirmation_instructions": {"subject": "Verify your Account"},
                "reset_password_instructions": {"subject": "Reset password instructions"},
                "unlock_instructions": {"subject": "Unlock Instructions"}
            },
            "omniauth_callbacks": {
                "failure": "Could not authenticate you from %{kind} because \"%{reason}\".",
                "success": ""
            },
            "passwords": {
                "no_token": "You can't access this page without coming from a password reset email. If you do come from a password reset email, please make sure you used the full URL provided.",
                "send_instructions": "You will receive an email with instructions on how to reset your password in a few minutes. Please check your Junk folder as your mail could have been marked as spam.",
                "send_paranoid_instructions": "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.",
                "updated": "Your password was changed successfully.",
                "updated_not_active": "Your password was changed successfully."
            },
            "registrations": {
                "destroyed": "Bye! Your account was successfully cancelled. We hope to see you again soon.",
                "signed_up": "Welcome! You have signed up successfully.",
                "signed_up_but_inactive": "You have signed up successfully. However, we could not sign you in because your account is not yet activated.",
                "signed_up_but_locked": "You have signed up successfully. However, we could not sign you in because your account is locked.",
                "signed_up_but_unconfirmed": "A confirmation link has been dispatched to your email address. Please open the link to activate your account. In case you don't receive the mail, please check your Junk folder.",
                "update_needs_confirmation": "Your account was successfully updated, but we need to verify your new email address. Please check your email and click on the confirmation link to complete the verification.",
                "updated": "Your account was updated successfully."
            },
            "sessions": {"signed_in": "", "signed_out": "", "already_signed_out": "Signed out successfully."},
            "unlocks": {
                "send_instructions": "You will receive an email with instructions about how to unlock your account in a few minutes.",
                "send_paranoid_instructions": "If your account exists, you will receive an email with instructions about how to unlock it in a few minutes.",
                "unlocked": "Your account has been unlocked successfully. Please log in to continue."
            },
            "password_resets": {
                "no_token": "You can't access this page without coming from a password reset email. If you arrived through a password reset email, please make sure you used the complete URL provided.",
                "send_instructions": "You will receive an email with instructions about how to reset your password in a few minutes. Please check your Junk folder as your mail could have been marked as spam.",
                "send_paranoid_instructions": "If your email address exists in our database, you will receive a password recovery link at your email address in a few minutes.",
                "updated": "Your password was changed successfully. You are now logged in.",
                "updated_not_active": "Your password was changed successfully."
            }
        },
        "notifier": null,
        "user_verify_email_subject": "PairCon Account Activation",
        "delivered_via": "Delivered via",
        "shared_source": " through the link you shared via %{source}. ",
        "email_footer": "To change your settings for email notifications, \u003ca href=\"%{href_path}\"\u003eclick here\u003c/a\u003e",
        "personal_information_updated": "Your personal information has been updated.",
        "timezone_updated_success_msg": "Your time zone has been updated.",
        "email_password_updated": "Your email address and password have been updated.",
        "notifications_updated": "Your notifications settings have been updated.",
        "sure_to_del_user": "Are you sure you want to delete this user?",
        "user_deleted": "The user has been deleted.",
        "user_updated": "User information has been updated.",
        "user_created": "Your invitation was successfully sent to %{email_address}",
        "delete_status": "Delete Status",
        "save_msg": "Your settings have been saved.",
        "contacts_count": {
            "one": "You have selected %{count} contact.",
            "other": "You have selected %{count} contacts."
        },
        "app_msg_sent_success_msg": "Your message has been successfully sent.",
        "incorrect_pic_format": "Incorrect file format. Only gif, jpg, jpeg, and png file types are allowed.",
        "please_try_again": "Please try again. If the problem persists, please contact \u003ca href=\"mailto:%{support_email}\"\u003e%{support_email}\u003c/a\u003e.",
        "file_del_msg": "Are you sure you want to delete this file?",
        "atleast_one_option_req_msg": "At least one option is required.",
        "account_not_found": "No account found.",
        "email_required_field": "Email field is required.",
        "hint_text": "Please type name or email and then press enter",
        "no_results_text": "No results found",
        "searching_text": "Looking for email address...",
        "invalid_token_text": "Enter a valid email address",
        "user_status_inactive_tooltip": "Change this user's status to inactive",
        "user_status_active_tooltip": "Change this user's status to active",
        "message_not_sent_due_to_filesize": "Your message could not be sent due to file size. File size cannot be more than 1MB.",
        "invalid_url_msg": "Please enter a valid URL.",
        "url_protocol_not_required_msg": "Please specify the valid URL without 'http://' or 'https://'",
        "no_special_chars_allowed_msg": "No special characters allowed.",
        "user_status_to_active_msg": "%{user_name} is now active and will be able to log in.",
        "user_status_to_inactive_msg": "%{user_name} is now inactive and will not be able to log in.",
        "invalid_msg": "Invalid",
        "file_uploaded_success_msg": "The file has been successfully added.",
        "select_file_msg": "Please select a file.",
        "user_assigned_success_msg": "User has been successfully assigned.",
        "user_unassigned_success_msg": "User has been successfully unassigned.",
        "user_not_found": "No user found.",
        "https_access_error_msg": "Please type https:// instead of http:// before your URL in order to access this page securely.",
        "server_busy_msg": "Please try after some time, server is busy.",
        "error_uploading_att_file": "There was an error while uploading the attachment. Please try again.",
        "supported_not_supported_format": "This format is not supported. Supported formats are doc, txt, pdf, docx, rtf, png, gif, jpg, jpeg, rar, zip, ppt, xls, xlsx.",
        "invalid_email": "Invalid email or password. Please try again ...",
        "email_not_found": "Sorry, we couldn't find anyone with that email address.",
        "tag_updated": "Your tag has been successfully renamed.",
        "tag_deleted": " has been successfully deleted.",
        "password_sent": "An email has been sent to %{email_address} with instructions on how to obtain your new password.",
        "settings_updated": "Your settings have been updated",
        "subject_required": "Subject field is required",
        "message_required": "Message field is required",
        "invalid_email_address_msg": "Please enter a valid email address",
        "required_field_msg": "This field is required",
        "pls_enter_same_value_msg": "Value appears to be incorrect",
        "pls_enter_at_least_characters": "Please enter at least {0} characters.",
        "error_delete_msg": "Unable to delete at this time. Please try again.",
        "confirm_disable_user_msg": "Are you sure you want to disable this user?",
        "confirm_delete_msg": "Are you sure you want to delete?",
        "tag_created": "Tag has been successfully created.",
        "invalid_feed_request": "The feed request is invalid.",
        "no_feed_request": "No Feed Request",
        "users_not_exist": "No users exist.",
        "invitation_sent": "Invitation has been sent.",
        "invitation_not_sent": "Invitation has not been sent.",
        "pls_enter_valid_number": "Please enter a valid number.",
        "pls_enter_value_less_or_equal_max": "Please enter a value less than or equal to {0}.",
        "please_fix_errors_msg": "Please fix the highlighted errors and try again.",
        "email": "Email",
        "deleting": "Deleting...",
        "uploading": "Uploading...",
        "submitting": "Submitting...",
        "loading": "Loading...",
        "all": "All",
        "select": "Select",
        "first_name": "First Name",
        "last_name": "Last Name",
        "search": "Search",
        "tags": "Tags",
        "display": "Display",
        "cloud": "Cloud",
        "list": "List",
        "sort_by": "Sort by",
        "freq": "Freq",
        "alpha": "Alpha",
        "preview": "Preview",
        "download": "Download",
        "name": "Name",
        "first": "First",
        "last": "Last",
        "messages": "Messages",
        "rating": "Rating",
        "subject": "Subject",
        "applications": "Applications",
        "archive": "Archive",
        "unarchive": "Unarchive",
        "required_fields": "Required fields",
        "save": "Save",
        "cancel": "Cancel",
        "summary": "Summary",
        "updates_from_last": "Updates from the last %{hours} hours",
        "new_apps_rec": "new applications received",
        "dashboard": "Dashboard",
        "today": "Today",
        "day": "Day",
        "week": "Week",
        "month": "Month",
        "year": "Year",
        "from": "From",
        "sent_to": "sent to",
        "reply": "Reply",
        "no_new_messages": "No new messages",
        "submit": "Submit",
        "all_rights_reserved": "All rights reserved",
        "settings": "Settings",
        "general": "General",
        "logo": "Logo",
        "feedback": "Feedback",
        "email_required": "Email field is required",
        "email_incorrect": "Email format is incorrect",
        "first_name_required": "First name field is required",
        "provide_correct_values": "Provide correct values and try again",
        "add_new": "Add New",
        "untitled": "Untitled",
        "question_type": "Question Type",
        "single_line": "Single Line Text",
        "paragraph": "Paragraph Text",
        "multiple": "Multiple Choice",
        "drop_down": "Drop Down",
        "checkboxes": "Checkboxes",
        "upload_file": "Upload File",
        "choices": "Choices",
        "required_ques": "Required Question",
        "click_to_edit": "Click to edit. Drag to reorder",
        "browse_by": "Browse By",
        "status": "Status",
        "your_tags": "Your Tags",
        "welcome": "Welcome",
        "my_account": "My Profile",
        "sign_out": "Sign out",
        "send_feedback": "Send Feedback",
        "privacy_policy": "Privacy Policy",
        "address_1": "Street Address 1",
        "address_2": "Street Address 2",
        "city": "City",
        "state": "State",
        "province": "Province",
        "zip": "Zip / Postal Code",
        "country": "Country",
        "fax": "Fax",
        "edit_location": "Edit Location",
        "update": "Update",
        "saved": "saved",
        "rec_from": "wrote",
        "rep_from": "Reply from",
        "add_a_task": "Add a task",
        "what_task": "What is the task?",
        "when_due": "When is it due?",
        "tomorrow": "Tomorrow",
        "this_week": "This week",
        "next_week": "Next week",
        "later": "Later",
        "specific_date": "Specific Date/Time",
        "set_time": "Set time",
        "what_time": "At what time?",
        "dont_time": "Don't set time",
        "who_responsible": "Who is responsible?",
        "calendar": "Calendar",
        "phone_numbers": "Phone numbers",
        "work": "Work",
        "change_your_pass": "Change your password",
        "new_pass": "New Password",
        "send": "Send",
        "contactus_info": "If you have any questions about the product or you wish to request a demo, please fill in the form below and we will get in touch with you as soon as possible",
        "at": "at",
        "web_url": "Company URL: http://",
        "late": "late",
        "due_today": "Due Today",
        "due_tomorrow": "Due Tomorrow",
        "due_next_week": "Due Next Week",
        "due_later": "Due Later",
        "due_this_week": "Due This Week",
        "finish": "Finish",
        "selected": "Selected",
        "manage_tags": "Manage Tags",
        "save_and_continue": "Save and Continue",
        "previous": "Previous",
        "assigned_to": "Assigned to",
        "me": "Me",
        "assigned_by": "Assigned by",
        "completed_on": "completed on",
        "account": "account",
        "language": "Language",
        "optional": "Optional",
        "due": "Due",
        "due_at": "Due at ",
        "due_this": "Due this ",
        "due_on": "Due on ",
        "note": "Note",
        "send_message": "Send message",
        "add_note": "Add Note",
        "content": "Content",
        "color": "Color",
        "colors": "Colors",
        "section": "Section",
        "header": "Header",
        "text": "Text",
        "titles": "Titles",
        "bg": "Background",
        "page": "Page",
        "years": "years",
        "add_question": "Add Question",
        "or": "or",
        "careers": "Careers",
        "your": "Your",
        "posted_date": "Date posted",
        "blog": "Blog",
        "for": "For",
        "duplicate": "Clone",
        "options": "Options",
        "file_name": "File Name",
        "code": "Code",
        "price": "Price",
        "email_support": "E-mail Support",
        "new_stage": "New status",
        "move_candidates": "Move Candidates",
        "select_status_message": "Please select a status.",
        "statuses_select_first_text": "-- Select Status --",
        "package": "Package",
        "upgrading": "upgrading",
        "downgrading": "downgrading",
        "change_account_admin": "Change Account Administrator",
        "confirmation": "confirmation",
        "address": "Address",
        "contact_details": "Contact Details",
        "open": "Open",
        "apply": "Apply",
        "reset_password_verify_message": "To verify your new password, please enter it once in each field below",
        "set_password_verify_message": "To activate your account, please set your password",
        "welcome_email_message": "Welcome to PairCon",
        "account_page": "account page",
        "cc_info": "Credit Card Information",
        "thanks_for_using_cloudmerge": "Thank you for using PairCon.",
        "quantity": "Quantity",
        "share": "Share",
        "show_quoted_text": "- Show quoted text -",
        "hide_quoted_text": "- Hide quoted text -",
        "size": "Size",
        "download_excel": "Download Excel",
        "download_pdf": "Download PDF",
        "status_pipeline": "Status Pipeline",
        "percentage": "Percentage",
        "male": "MALE",
        "female": "FEMALE",
        "no_answer": "NO ANSWER",
        "hired_total": "Hired/Total",
        "all_job": "All jobs",
        "sign_up_for_free": "Sign Up for Free.",
        "take_a_tour": "Take a tour",
        "PairCon": "Cloud Merge",
        "about_us": "About Us",
        "faq": "Frequently Asked Questions",
        "personal_information": "Personal Information",
        "my_info": "My Info",
        "search_now": "Search Now",
        "is_exactly": "is exactly",
        "contains": "contains",
        "does_not_contain": "does not contain",
        "is_greater_than": "is greater than",
        "is_greater_or_equal_to": "is greater or equal to",
        "is_less_than": "is less than",
        "is_less_than_or_equal_to": "is less than or equal to",
        "email_address": "Email Address",
        "email_updated": "Email Address successfully updated.",
        "displaying": "Displaying",
        "records": "records",
        "total_amount": "Total amount(for all fetched records)",
        "expirydate": "Expiry Date",
        "network": "Network",
        "connected_profile": "Connected Profile",
        "connected_page": "Connected Page",
        "jobs": "Jobs",
        "reports": "Reports",
        "about": "About",
        "press": "Press",
        "privacy": "Privacy",
        "terms": "Terms",
        "help": "Help",
        "allow_job_publishing": "Allow Job Publishing",
        "advanced_search": "Advanced Search",
        "set_statuses_to": "Set Status to...",
        "contact_us": "Contact Us",
        "default": "Default",
        "personal_info": "Personal Info",
        "time_zone": "Time Zone",
        "email_password": "Email \u0026 Password",
        "notifications": "Notifications",
        "google_account": "Google Account",
        "google_apps": "Google Apps",
        "password": "Password",
        "rem_me": "Remember me",
        "forgot_pass": "Forgot Your Password?",
        "logging_in": "Logging In...",
        "already_have_account": "Already have a PairCon account?",
        "click_here": "Click here",
        "confirm_password": "Confirm Password",
        "create_account": "Create Account",
        "connect_account": "Connect Account",
        "xml_job_feed": "XML Job Feed",
        "details": "Details",
        "terms_of_use": "Terms of Service",
        "signup": "Sign Up",
        "free_trial_desc": "For a Free %{trial_period}-Day Trial",
        "signing_up_plan_desc": "You're signing up for the %{account_title} plan.",
        "view_other_plans": "View other available plans",
        "send_me_newsletter": "Send me newsletter",
        "activate_your_account": "Activate Your Account",
        "thank_you_verifying_email_address": "Thank you for verifying your email address.",
        "company": "Company",
        "enter_password_to_activate_account": "Please enter a password to activate your PairCon account.",
        "activate_account": "Activate Account",
        "cloudmerge_copyright": "© 2015 PairCon.",
        "back_to": "« back to",
        "notifications_options": {"0": "All", "1": "Drives", "2": "Tags", "3": "Files"},
        "last_login": "Last Login",
        "actions": "Actions",
        "edit_user": "Edit User",
        "back": "Back",
        "required_info": "Required Info",
        "view_all_files": "View All Files",
        "attach_files": "Attach Files",
        "delete_all_files": "Delete All Files",
        "remove": "Remove",
        "back_to_users_and_roles": "Back to Users \u0026 Roles",
        "user_status": "User Status",
        "active": "Active",
        "inactive": "Inactive",
        "log_in_here": "Log In here.",
        "ok": "OK",
        "view_all_notifications": "View All Notifications",
        "log_out": "Log out",
        "you_are_logged_into": "You are logged into:",
        "do_not_have_account": "Don't have an account?",
        "all_time": "All Time",
        "last_x_days": "Last %{days} days",
        "contact": "Contact",
        "support_center": "Support Center",
        "knowledge_base": "Knowledge Base",
        "contact_support": "Contact Support",
        "give_feedback": "Give Feedback",
        "disconnect": "Disconnect",
        "back_to_login": "Back to Log In",
        "reset_password": "Reset Password",
        "set_password": "Set Password",
        "saving": "Saving...",
        "general_information": "General Information",
        "sign_up_date": "SignUp Date",
        "domain": "Domain",
        "top_five_tags": "Top five tags",
        "last_30_days_activities": "Activities within last 30 days",
        "user_full_name": "My Full Name",
        "user_first_name": "My First Name",
        "user_last_name": "My Last Name",
        "user_email": "My Email",
        "done": "Done",
        "bulk_upload": "Bulk Upload",
        "tags_index_desc": "Following Tags can be associated with your Files / Folders",
        "new_tag": "New Tag",
        "close": "Close",
        "files": "Files",
        "delete": "Delete",
        "cloud_desc": "To allow PairCon to merge a %{name} account with your PairCon account, please a name for drive and click the Finish button. If you don't have a Box account, then click \u003ca href='%{link}'\u003ehere\u003c/a\u003e to register."
    },
    "pt-BR": {
        "errors": {
            "messages": {
                "in_between": "deve ter entre %{min} e %{max}",
                "spoofed_media_type": "tem uma extensão que não corresponde ao seu conteúdo"
            }
        },
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "zh-HK": {
        "errors": {"messages": {"in_between": "必須介於%{min}到%{max}之間", "spoofed_media_type": "副檔名與內容類型不匹配"}},
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "zh-TW": {
        "errors": {"messages": {"in_between": "檔案大小必須介於 %{min} 到 %{max} 之間", "spoofed_media_type": "副檔名與內容類型不符"}},
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "es": {
        "errors": {
            "messages": {
                "in_between": "debe estar entre %{min} y %{max}",
                "spoofed_media_type": "tiene una extensión que no coincide con su contenido"
            }
        },
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "zh-CN": {
        "errors": {"messages": {"in_between": "文件大小必须介于 %{min} 到 %{max} 之间", "spoofed_media_type": "扩展名与内容类型不符"}},
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "ja": {
        "errors": {
            "messages": {
                "in_between": "の容量は%{min}以上%{max}以下にしてください。",
                "spoofed_media_type": "の拡張子と内容が一致していません。"
            }
        },
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    },
    "de": {
        "errors": {
            "messages": {
                "in_between": "muss zwischen %{min} und %{max} sein",
                "spoofed_media_type": "trägt eine Dateiendung, die nicht mit dem Inhalt der Datei übereinstimmt"
            }
        },
        "number": {
            "human": {
                "storage_units": {
                    "format": "%n %u",
                    "units": {"byte": {"one": "Byte", "other": "Bytes"}, "kb": "KB", "mb": "MB", "gb": "GB", "tb": "TB"}
                }
            }
        }
    }
};