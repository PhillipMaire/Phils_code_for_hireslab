function str1 = OSconv(str1)
    str1(str1=='\') = filesep;
    str1(str1=='/') = filesep;
