import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { CreateLogDto } from '../../logs/dto/create-log.dto';
import CreateLogException from '../../logs/exceptions/CreateLogException';

@Injectable()
export class CreateLogValidatorPipe
  implements PipeTransform<CreateLogDto, CreateLogDto>
{
  /**
   * This class validates log creation
   * @param value
   * @param metadata
   * @returns
   */
  transform(value: CreateLogDto, metadata: ArgumentMetadata) {
    if (!value.action) {
      throw new CreateLogException('action is required');
    }

    if (!value.payload) {
      throw new CreateLogException('payload is required');
    }

    if (!value.timestamp) {
      throw new CreateLogException('timestamp is required');
    }

    return value;
  }
}
