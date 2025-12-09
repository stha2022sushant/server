from django.db import models
from django.contrib.auth import get_user_model
from apps.generics.models import GenericTimeStampModel
from apps.generics.validators.character_validators import (
    no_special_chars_validator,
)

# from generics.validators import validate_phone_number

User = get_user_model()


class AdminProfile(GenericTimeStampModel):
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="admin_profile"
    )
    first_name = models.CharField(
        max_length=50, validators=[no_special_chars_validator]
    )
    last_name = models.CharField(max_length=50, validators=[
                                 no_special_chars_validator])
    phone_no = models.CharField(
        max_length=15,
        unique=True,
        help_text=(
            "Enter valid contact number starting from +977"
        ),
        null=True,
        blank=False,
    )

    @property
    def full_name(self) -> str:
        return f"{self.first_name} {self.last_name}"

    def __str__(self) -> str:
        return self.full_name

    def clean(self):
        # Normalize phone number (remove spaces)
        if self.phone_no:
            self.phone_no = self.phone_no.replace(" ", "")
            self.phone_no = self.phone_no.replace("-", "")
        super().clean()

    def save(self, *args, **kwargs):
        self.clean()
        super().save(*args, **kwargs)


class CustomerProfile(GenericTimeStampModel):
    user = models.OneToOneField(
        User, on_delete=models.CASCADE, related_name="customer_profile"
    )
    company_name = models.CharField(
        max_length=50, unique=True, validators=[no_special_chars_validator]
    )
    phone_number = models.CharField(max_length=20, unique=True)

    def __str__(self) -> str:
        return self.company_name


