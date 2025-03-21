package connector;

import org.junit.Assert;
import org.junit.Test;
import util.TestUtils;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

/**
 * 测试response
 */
public class ResponseTest {

    private static final String validRequest = "GET /index.html HTTP/1.1";
    private static final String invalidRequest = "GET /notfound.html HTTP/1.1";

    private static final String status200 = "HTTP/1.1 200 OK\r\n\r\n";
    private static final String status404 = "HTTP/1.1 404 File Not Found\r\n\r\n";

    /**
     * 有效的请求响应测试
     *
     * @throws IOException
     */
    @Test
    public void givenValidRequest_thenReturnStaticResource() throws IOException {
        // 创建 Request 对象
        Request request = TestUtils.createRequest(validRequest);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        // 创建 Response 对象
        Response response = new Response(out);
        response.setRequest(request);
        response.sendStaticResource();

        String resource = TestUtils.readFileToString(ConnectorUtils.WEB_ROOT + request.getRequestURI());
        Assert.assertEquals(status200 + resource, out.toString());
    }

    /**
     * 无效的请求响应测试
     *
     * @throws IOException
     */
    @Test
    public void givenInvalidRequest_thenReturnError() throws IOException {
        Request request = TestUtils.createRequest(invalidRequest);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        Response response = new Response(out);
        response.setRequest(request);
        response.sendStaticResource();

        String resource = TestUtils.readFileToString(ConnectorUtils.WEB_ROOT + "/404.html");
        Assert.assertEquals(status404 + resource, out.toString());
    }
}
