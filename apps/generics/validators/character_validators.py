import re
from django.core.validators import RegexValidator
from rest_framework.exceptions import ValidationError


no_special_chars_validator = RegexValidator(
    regex=r"""^[a-zA-Z0-9\s.,'\-]*$""",
    message="Can not contain special characters.",
    code="invalid_characters",
)


def validate_no_special_chars(value):
    """
    Function-based validator to ensure a string doesn't contain special characters.
    Use this in serializers by adding to the validators list.

    Example:
        class MySerializer(serializers.ModelSerializer):
            name = serializers.CharField(validators=[validate_no_special_chars])

    Args:
        value: The string to validate

    Raises:
        ValidationError: If the string contains special characters
    """
    if not re.match(r"""^[a-zA-Z0-9\s.,'\-]*$"""):
        raise ValidationError("Can not contain special characters.")
    return value
