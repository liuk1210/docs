### 📦 本地jar包导入maven仓库
~~~
mvn install:install-file -Dfile=*.jar -DgroupId= -DartifactId= -Dversion= -Dpackaging=jar -DgeneratePom=true
~~~
### 🔧 生成maven本地jar包导入语句
~~~
public class Maven {
    public static void main(String[] args) {
        String notFind = "groupId:artifactId:version";
        String[] notFinds = notFind.split("\n");
        for (String pak : notFinds) {
            String[] pakSplit = pak.split(":");
            String filePath = "d:/repository/" + (pakSplit[0].replaceAll("\\.", "/")) + "/" + pakSplit[1]
                    + "/" + pakSplit[2] + "/" + pakSplit[1] + "-" + pakSplit[2] + ".jar";
            System.out.println("mvn install:install-file -Dfile=" +
                    filePath + " -DgroupId=" + pakSplit[0] + " -DartifactId=" + pakSplit[1] + " -Dversion=" + pakSplit[2]
                    + " -Dpackaging=jar -DgeneratePom=true");
        }
    }
}
~~~