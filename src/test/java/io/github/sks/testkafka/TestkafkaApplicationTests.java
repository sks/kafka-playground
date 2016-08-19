package io.github.sks.testkafka;

import static org.junit.Assert.assertTrue;

import java.util.concurrent.TimeUnit;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class TestkafkaApplicationTests {

	@Test
	public void contextLoads() {
	}

	@Autowired
	private Listener listener;

	@Autowired
	private KafkaTemplate<Integer, String> template;

	@Test
	public void testSimple() throws Exception {
		this.template.send("annotated1", 0, "foo");
		assertTrue(this.listener.latch1.await(10, TimeUnit.SECONDS));
	}

}
