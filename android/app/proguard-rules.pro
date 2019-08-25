#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-dontnote android.net.http.*
-dontnote org.apache.commons.codec.**
-dontnote org.apache.http.**
-dontwarn android.support.v4.**
# GooglePlay Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**
-keep class com.google.common.** { *; }
-dontwarn com.google.common.**
-keepnames class org.apache.** {*;}
-keep class com.shockwave.**

-keep public class org.apache.** {*;}
-dontwarn org.apache.commons.logging.LogFactory
-dontwarn org.apache.http.annotation.ThreadSafe
-dontwarn org.apache.http.annotation.Immutable
-dontwarn org.apache.http.annotation.NotThreadSafe
-dontwarn com.nhaarman.listviewanimations.**
-dontnote android.net.http.*
-dontwarn org.apache.http.**
-dontwarn okio.**
-dontwarn com.google.android.firebase.appindexing.internal.zzb
-keep class com.google.android.firebase.appindexing.internal.** { *; }