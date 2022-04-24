String? validateEmail(String? value) {    
      if (value != null) {
        if (value.length > 5 && value.contains('@') && value.endsWith('.com')) {
          return null;
        }
     return 'Please Enter a valid email address.';
    }
}
