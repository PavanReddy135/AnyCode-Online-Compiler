package anycode;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;

@WebServlet("/codecompiler")
public class CodeCompiler extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("code");
        String language = request.getParameter("language");
        String input = request.getParameter("input");

        String fileName = "Program";
        String extension = "";
        String compileCmd = "";
        String runCmd = "";

        switch (language) {
            case "java":
                extension = ".java";
                compileCmd = "javac " + fileName + extension;
                runCmd = "java -cp . " + fileName;
                break;
            case "c":
                extension = ".c";
                compileCmd = "gcc " + fileName + extension + " -o " + fileName + ".exe";
                runCmd = fileName + ".exe";
                break;
            case "cpp":
                extension = ".cpp";
                compileCmd = "g++ " + fileName + extension + " -o " + fileName + ".exe";
                runCmd = fileName + ".exe";
                break;
            case "python":
                extension = ".py";
                runCmd = "python " + fileName + extension;
                break;
            case "javascript":
                extension = ".js";
                runCmd = "node " + fileName + extension;
                break;
            case "go":
                extension = ".go";
                runCmd = "go run " + fileName + extension;
                break;
            case "ruby":
                extension = ".rb";
                runCmd = "ruby " + fileName + extension;
                break;
            default:
                request.setAttribute("output", "Unsupported language.");
                request.getRequestDispatcher("index.jsp").forward(request, response);
                return;
        }

        
        File dir = new File("C:\\temp\\anycode");
        if (!dir.exists()) dir.mkdirs();

        
        File codeFile = new File(dir, fileName + extension);
        try (FileWriter fw = new FileWriter(codeFile)) {
            fw.write(code);
        }

        StringBuilder output = new StringBuilder();

        
        if (!compileCmd.isEmpty()) {
            output.append(executeCommand(compileCmd, dir, null));
        }

        
        output.append(executeCommand(runCmd, dir, input));

        request.setAttribute("output", output.toString());
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private String executeCommand(String command, File dir, String input) throws IOException {
        StringBuilder result = new StringBuilder();

        ProcessBuilder pb;
        if (System.getProperty("os.name").toLowerCase().contains("win")) {
            pb = new ProcessBuilder("cmd.exe", "/c", command);
        } else {
            pb = new ProcessBuilder("/bin/sh", "-c", command);
        }

        pb.directory(dir);
        Process process = pb.start();

        
        if (input != null && !input.trim().isEmpty()) {
            try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()))) {
                writer.write(input);
                writer.newLine();
                writer.flush();
            }
        }

       
        String line;
        try (BufferedReader stdOut = new BufferedReader(new InputStreamReader(process.getInputStream()));
             BufferedReader stdErr = new BufferedReader(new InputStreamReader(process.getErrorStream()))) {

            while ((line = stdOut.readLine()) != null) {
                result.append(line).append("\n");
            }

            while ((line = stdErr.readLine()) != null) {
                result.append(line).append("\n");
            }
        }

        try {
            process.waitFor();
        } catch (InterruptedException e) {
            result.append("Process interrupted.\n");
        }

        return result.toString();
    }
}
