import { KafkaOptions, Transport } from '@nestjs/microservices';
import { config } from 'dotenv';
config();
export const microserviceConfig: KafkaOptions = {
  transport: Transport.KAFKA,
  options: {
    client: {
      brokers: [process.env.BROKER],
    },
    consumer: {
      groupId: 'logs-producer',
      allowAutoTopicCreation: true,
    },
  },
};
